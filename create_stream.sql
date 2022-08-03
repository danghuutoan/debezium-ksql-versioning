
CREATE STREAM orders_from_debezium  WITH (KAFKA_TOPIC='dbserver.inventory.orders', VALUE_FORMAT='AVRO');

create stream order_create_events with (KAFKA_TOPIC='order_create_events', VALUE_FORMAT='AVRO') as select after->ORDER_NUMBER , after->ORDER_DATE , after->PURCHASER , after->QUANTITY , after->PRODUCT_ID , after->_updated_time, cast(NULLIF('true', 'true') as BIGINT) as _valid_to from orders_from_debezium where op in ('r', 'c');
create stream order_update_old_events with (KAFKA_TOPIC='order_update_old_events' , VALUE_FORMAT='AVRO') as select before->ORDER_NUMBER , before->ORDER_DATE , before->PURCHASER , before->QUANTITY , before->PRODUCT_ID , before->_updated_time, after->_updated_time as _valid_to  from orders_from_debezium where op = 'u';
create stream order_update_new_events with (KAFKA_TOPIC='order_update_new_events', VALUE_FORMAT='AVRO') as select after->ORDER_NUMBER , after->ORDER_DATE , after->PURCHASER , after->QUANTITY , after->PRODUCT_ID , after->_updated_time, cast(NULLIF('true', 'true') as BIGINT) as _valid_to  from orders_from_debezium where op = 'u';
create stream order_delete_events with (KAFKA_TOPIC='order_delete_events', VALUE_FORMAT='AVRO') as select before->ORDER_NUMBER , before->ORDER_DATE , before->PURCHASER , before->QUANTITY , before->PRODUCT_ID , before->_updated_time, ts_ms as _valid_to  from orders_from_debezium where op = 'd';


insert into order_create_events select * from order_update_new_events;
insert into order_create_events select * from order_update_old_events;
insert into order_create_events select * from order_delete_events;