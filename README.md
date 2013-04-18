magento-lite-db-dump
====================

Shell script that dumps a reduced version of the Magento database for use in
development.

This script dumps the entire database structure but leaves many tables empty.
These are generally tables corresponding to logs, customers, orders, wishlists,
etc.

The result is a more lightweight file to download, and does not contain
potentially sensitive customer data.

This would ideally be imported into the local database environment. I always
follow this with a second script that updates the development environment. The
most basic version of this would look something like this:

    UPDATE core_config_data SET value = 'http://magento.dev/' WHERE path = 'web/unsecure/baseurl';
    UPDATE core_config_data SET value = 'http://magento.dev/' WHERE path = 'web/secure/baseurl';

Probably you would have other configurations you should change too.

Usage
=====

Called from the command line, dumper.sh has the following options:
*   -h help
*   -d database
*   -u username
*   -p password
*   -g flag to gzip the resulting file.

The script produces a filename called $dbname.dump.sql(.gz)

The following tables are left empty:

*   api_session
*   core_session
*   customer_address_entity
*   customer_address_entity_datetime
*   customer_address_entity_decimal
*   customer_address_entity_int
*   customer_address_entity_text
*   customer_address_entity_varchar
*   customer_entity
*   customer_entity_decimal
*   customer_entity_int
*   customer_entity_text
*   customer_entity_varchar
*   dataflow_session
*   enterprise_customer_sales_flat_order
*   enterprise_customer_sales_flat_order_address
*   enterprise_customer_sales_flat_quote
*   enterprise_customer_sales_flat_quote_address
*   enterprise_customerbalance
*   enterprise_customerbalance_history
*   enterprise_customersegment_customer
*   log_customer
*   log_quote
*   log_summary
*   log_summary_type
*   log_url
*   log_url_info
*   log_visitor
*   log_visitor_info
*   log_visitor_online
*   persistent_session
*   sales_bestsellers_aggregated_daily
*   sales_bestsellers_aggregated_monthly
*   sales_bestsellers_aggregated_yearly
*   sales_billing_agreement
*   sales_billing_agreement_order
*   sales_flat_creditmemo
*   sales_flat_creditmemo_comment
*   sales_flat_creditmemo_grid
*   sales_flat_creditmemo_item
*   sales_flat_invoice
*   sales_flat_invoice_comment
*   sales_flat_invoice_grid
*   sales_flat_invoice_item
*   sales_flat_order
*   sales_flat_order_address
*   sales_flat_order_grid
*   sales_flat_order_item
*   sales_flat_order_payment
*   sales_flat_order_status_history
*   sales_flat_quote
*   sales_flat_quote_address
*   sales_flat_quote_address_item
*   sales_flat_quote_item
*   sales_flat_quote_item_option
*   sales_flat_quote_payment
*   sales_flat_quote_shipping_rate
*   sales_flat_shipment
*   sales_flat_shipment_comment
*   sales_flat_shipment_grid
*   sales_flat_shipment_item
*   sales_flat_shipment_track
*   sales_invoiced_aggregated
*   sales_invoiced_aggregated_order
*   sales_order_aggregated_created
*   sales_order_aggregated_updated
*   sales_order_status
*   sales_order_status_label
*   sales_order_status_state
*   sales_order_tax
*   sales_order_tax_item
*   sales_payment_transaction
*   sales_recurring_profile
*   sales_recurring_profile_order
*   sales_refunded_aggregated
*   sales_refunded_aggregated_order
*   sales_shipping_aggregated
*   sales_shipping_aggregated_order
*   salesrule
*   salesrule_coupon
*   salesrule_coupon_usage
*   salesrule_customer
*   salesrule_customer_group
*   salesrule_label
*   salesrule_product_attribute
*   salesrule_website
*   wishlist
*   wishlist_item
*   wishlist_item_option
