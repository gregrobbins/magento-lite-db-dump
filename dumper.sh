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
    --ignore-table $DBNAME.admin_user \
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
    >> $DBNAME.dump.sql

    echo "LOCK TABLES admin_user WRITE;" >> $DBNAME.dump.sql
    echo "/*!40000 ALTER TABLE admin_user DISABLE KEYS */;" >> $DBNAME.dump.sql
    echo "INSERT INTO admin_user VALUES (47,'Ad','Min','admin@docusign.com','admin','69c3f890217c41943cdd4ca73d99fec97a9350407106c571a0eb8b94a0e07e2d:D1','2015-03-30 18:57:04','2015-03-31 01:56:52','2015-03-31 01:57:04',1,0,1,'N;',NULL,NULL,0,NULL,NULL);" >> $DBNAME.dump.sql
    echo "/*!40000 ALTER TABLE admin_user ENABLE KEYS */;" >> $DBNAME.dump.sql
    echo "UNLOCK TABLES;" >> $DBNAME.dump.sql

if [ "$GZIPFLAG" == 1 ]; then
    gzip $DBNAME.dump.sql
fi
