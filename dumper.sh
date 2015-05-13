#!/bin/bash
usage="$(basename "$0"): Dumps Magento database leaving customer, order, log data empty.
Creates a file called databasename.dump.sql(.gz)
Works only on localhost.

Usage:
    -d database
    -u username
    -p password
    -g gzip file on completion
    -h this help"

DBNAME=
USERNAME=
PASSWORD=
GZIPFLAG=0
while getopts d:u:p:gh opt
do
    case "$opt" in
        d) DBNAME="$OPTARG";;
        u) USERNAME="$OPTARG";;
        p) PASSWORD="$OPTARG";;
        g) GZIPFLAG=1;;
        h) echo "$usage" >&2
           exit 1;;
        ?) printf "illegal option '%s'\n" "$OPTARG" >&2
           echo "$usage" >&2
           exit 1;;
    esac
done
if [ "$DBNAME" == "" ]; then
    echo "Provide a database name: -d DBNAME" >&2
    exit 1
fi
PASSWORDISOK=`mysqladmin -u$USERNAME -p$PASSWORD ping | grep -c "mysqld is alive"`
if [ "$PASSWORDISOK" != 1 ]; then
    echo "Could not connect." >&2
    exit 1
fi

mysqldump -u$USERNAME -p$PASSWORD $DBNAME --no-data > $DBNAME.dump.sql
mysqldump -u$USERNAME -p$PASSWORD $DBNAME -t  \
    --ignore-table $DBNAME.log_customer \
    --ignore-table $DBNAME.log_quote \
    --ignore-table $DBNAME.log_summary \
    --ignore-table $DBNAME.log_summary_type \
    --ignore-table $DBNAME.log_url \
    --ignore-table $DBNAME.log_url_info \
    --ignore-table $DBNAME.log_visitor \
    --ignore-table $DBNAME.log_visitor_info \
    --ignore-table $DBNAME.log_visitor_online \
    --ignore-table $DBNAME.api_session \
    --ignore-table $DBNAME.core_session \
    --ignore-table $DBNAME.dataflow_session \
    --ignore-table $DBNAME.persistent_session \
    --ignore-table $DBNAME.enterprise_customer_sales_flat_order \
    --ignore-table $DBNAME.enterprise_customer_sales_flat_order_address \
    --ignore-table $DBNAME.enterprise_customer_sales_flat_quote \
    --ignore-table $DBNAME.enterprise_customer_sales_flat_quote_address \
    --ignore-table $DBNAME.enterprise_customerbalance \
    --ignore-table $DBNAME.enterprise_customerbalance_history \
    --ignore-table $DBNAME.enterprise_customersegment_customer \
    --ignore-table $DBNAME.sales_bestsellers_aggregated_daily \
    --ignore-table $DBNAME.sales_bestsellers_aggregated_monthly \
    --ignore-table $DBNAME.sales_bestsellers_aggregated_yearly \
    --ignore-table $DBNAME.sales_billing_agreement \
    --ignore-table $DBNAME.sales_billing_agreement_order \
    --ignore-table $DBNAME.sales_flat_creditmemo \
    --ignore-table $DBNAME.sales_flat_creditmemo_comment \
    --ignore-table $DBNAME.sales_flat_creditmemo_grid \
    --ignore-table $DBNAME.sales_flat_creditmemo_item \
    --ignore-table $DBNAME.sales_flat_invoice \
    --ignore-table $DBNAME.sales_flat_invoice_comment \
    --ignore-table $DBNAME.sales_flat_invoice_grid \
    --ignore-table $DBNAME.sales_flat_invoice_item \
    --ignore-table $DBNAME.sales_flat_order \
    --ignore-table $DBNAME.sales_flat_order_address \
    --ignore-table $DBNAME.sales_flat_order_grid \
    --ignore-table $DBNAME.sales_flat_order_item \
    --ignore-table $DBNAME.sales_flat_order_payment \
    --ignore-table $DBNAME.sales_flat_order_status_history \
    --ignore-table $DBNAME.sales_flat_quote \
    --ignore-table $DBNAME.sales_flat_quote_address \
    --ignore-table $DBNAME.sales_flat_quote_address_item \
    --ignore-table $DBNAME.sales_flat_quote_item \
    --ignore-table $DBNAME.sales_flat_quote_item_option \
    --ignore-table $DBNAME.sales_flat_quote_payment \
    --ignore-table $DBNAME.sales_flat_quote_shipping_rate \
    --ignore-table $DBNAME.sales_flat_shipment \
    --ignore-table $DBNAME.sales_flat_shipment_comment \
    --ignore-table $DBNAME.sales_flat_shipment_grid \
    --ignore-table $DBNAME.sales_flat_shipment_item \
    --ignore-table $DBNAME.sales_flat_shipment_track \
    --ignore-table $DBNAME.sales_invoiced_aggregated \
    --ignore-table $DBNAME.sales_invoiced_aggregated_order \
    --ignore-table $DBNAME.sales_order_aggregated_created \
    --ignore-table $DBNAME.sales_order_aggregated_updated \
    --ignore-table $DBNAME.sales_order_tax \
    --ignore-table $DBNAME.sales_order_tax_item \
    --ignore-table $DBNAME.sales_payment_transaction \
    --ignore-table $DBNAME.sales_recurring_profile \
    --ignore-table $DBNAME.sales_recurring_profile_order \
    --ignore-table $DBNAME.sales_refunded_aggregated \
    --ignore-table $DBNAME.sales_refunded_aggregated_order \
    --ignore-table $DBNAME.sales_shipping_aggregated \
    --ignore-table $DBNAME.sales_shipping_aggregated_order \
    --ignore_table $DBNAME.customer_address_entity \
    --ignore_table $DBNAME.customer_address_entity_datetime \
    --ignore_table $DBNAME.customer_address_entity_decimal \
    --ignore_table $DBNAME.customer_address_entity_int \
    --ignore_table $DBNAME.customer_address_entity_text \
    --ignore_table $DBNAME.customer_address_entity_varchar \
    --ignore_table $DBNAME.customer_entity \
    --ignore_table $DBNAME.customer_entity_decimal \
    --ignore_table $DBNAME.customer_entity_int \
    --ignore_table $DBNAME.customer_entity_text \
    --ignore_table $DBNAME.customer_entity_varchar \
    --ignore_table $DBNAME.wishlist \
    --ignore_table $DBNAME.wishlist_item \
    --ignore_table $DBNAME.wishlist_item_option \
    --ignore_table $DBNAME.catalog_product_index_price_cl \
    --ignore_table $DBNAME.cataloginventory_stock_status_cl \
    --ignore_table $DBNAME.catalogsearch_fulltext_cl \
    --ignore_table $DBNAME.catalog_product_flat_cl \
    --ignore_table $DBNAME.enterprise_logging_event \
    --ignore_table $DBNAME.enterprise_logging_event_changes \
    --ignore_table $DBNAME.catalog_category_product_cat_tmp \
    --ignore_table $DBNAME.catalog_product_flat_* \
    --ignore_table $DBNAME.catalog_category_flat_* \
    >> $DBNAME.dump.sql
if [ "$GZIPFLAG" == 1 ]; then
    gzip $DBNAME.dump.sql
fi
