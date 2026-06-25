
> 💡 Обратите внимание: скидка (`dr_sdisc`) вычитается **один раз со всей строки чека**, а не умножается на количество. Это важно для корректности расчётов.

### Классификация ABC

Пороги классификации (стандарт Парето):
- **Класс A** — товары, дающие **80%** совокупного показателя (топ ~20% ассортимента)
- **Класс B** — товары, дающие **до 95%** совокупного показателя (следующие ~30%)
- **Класс C** — оставшиеся **5%** показателя (~50% ассортимента)

Классификация выполняется **независимо** по каждой из трёх метрик с помощью оконных функций `SUM() OVER(ORDER BY ... DESC)`.

---

## 💻 SQL-решение

Решение реализовано **одним запросом** с использованием CTE и оконных функций:

```sql
-- Шаг 1: агрегируем показатели по каждому товару
WITH abc_sales AS (
    SELECT
        dr_ndrugs AS product,
        SUM(dr_kol) AS amount,
        SUM(dr_kol * (dr_croz - dr_czak) - dr_sdisc) AS profit,
        SUM(dr_kol * dr_croz - dr_sdisc) AS revenue
    FROM sales
    GROUP BY dr_ndrugs
)
-- Шаг 2: классифицируем товары по каждой метrike через накопительную долю
SELECT
    product,
    CASE
        WHEN SUM(amount) OVER (ORDER BY amount DESC) / SUM(amount) OVER () <= 0.80 THEN 'A'
        WHEN SUM(amount) OVER (ORDER BY amount DESC) / SUM(amount) OVER () <= 0.95 THEN 'B'
        ELSE 'C'
    END AS amount_abc,
    CASE
        WHEN SUM(profit) OVER (ORDER BY profit DESC) / SUM(profit) OVER () <= 0.80 THEN 'A'
        WHEN SUM(profit) OVER (ORDER BY profit DESC) / SUM(profit) OVER () <= 0.95 THEN 'B'
        ELSE 'C'
    END AS profit_abc,
    CASE
        WHEN SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () <= 0.80 THEN 'A'
        WHEN SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () <= 0.95 THEN 'B'
        ELSE 'C'
    END AS revenue_abc
FROM abc_sales
ORDER BY product;


Почему именно такое решение?
✅ CTE (WITH) — разделяет логику на агрегацию и классификацию, что упрощает чтение
✅ Оконные функции — позволяют вычислить накопительную долю без самоJOIN'ов
✅ Один запрос — соответствует требованию задачи и работает эффективно
✅ Корректная обработка возвратов — отрицательные dr_kol автоматически учитываются через SUM()
