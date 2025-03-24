SELECT amount_paid,
    customer_email,
    customer_name,
    due_date,
    payment,
    TO_TIMESTAMP(created) AS created,
    TO_TIMESTAMP(updated) AS updated,
    status,
    invoice_pdf,
    amount_due
FROM operations."stripe_invoices"