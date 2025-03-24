SELECT
    ed.deal_id,
    ed.line_item_id,
    ed.contact_id,
    ed.deal_name,
    ed.properties_deal_currency_code,
    ed.properties_hubspot_owner_id,
    li.properties_name,
    li.properties_price,
    li.properties_amount,
    li.properties_hs_sku,
    li.properties_discount,
    li.properties_quantity,
    li.properties_description,
    li.properties_hs_term_in_months,
    li.properties_hs_total_discount,
    li.properties_hs_discount_percentage,
    li.properties_recurringbillingfrequency,
    li.properties_hs_billing_period_end_date,
    li.properties_hs_line_item_currency_code,
    li.properties_hs_billing_start_delay_days,
    li.properties_hs_billing_period_start_date,
    li.properties_hs_recurring_billing_end_date,
    li.properties_hs_recurring_billing_start_date,
    ROW_NUMBER() OVER (
        PARTITION BY ed.deal_id, ed.line_item_id, ed.contact_id
        ORDER BY li.updatedAt.member0 DESC
    ) AS row_num
FROM "operations.billing-project"."ExplodedDeals" ed
LEFT JOIN minio."partnership-apps"."line_items" AS li
    ON ed.line_item_id = li.id