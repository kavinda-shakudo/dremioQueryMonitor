    SELECT *
    FROM (
            SELECT customer_email_address AS customer_email,
                hometotalamt AS amount,
                txndate AS payment_date,
                SUBSTRING(
                    customer_email_address,
                    POSITION('@' IN customer_email_address) + 1
                ) as email_domain,
                hometotalamt as amount_due,
                'qbo' AS source
            FROM qbo_invoices_v2
            UNION ALL
            SELECT customer_email,
                amount_paid / 100.0 AS amount,
                created AS payment_date,
                SUBSTRING(
                    customer_email,
                    POSITION('@' IN customer_email) + 1
                ) as email_domain,
                amount_due/100.0 as amount_due,
                'stripe_invoices' AS source
            FROM stripe_invoices_v1
            WHERE amount_due <> 0 AND status IN ('paid', 'open')
            UNION ALL
            SELECT customer_email,
                amount,
                payment_date,
                CASE
                    WHEN POSITION('@' IN customer_email) > 0 THEN
                        SUBSTRING(customer_email FROM POSITION('@' IN customer_email) + 1)
                    ELSE 'domain_missing'
                END AS email_domain,
                amount_due,
                'stripe_charges' AS source
            FROM stripe_charges_emails
            WHERE customer_email IS NOT NULL         
        ) AS combined_payments
    ORDER BY payment_date DESC