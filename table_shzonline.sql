select DISTINCT on (client_id) заключен, date_added, lastname, firstname, secondname, identifier as telephone, name as packet_name , stringval as inn, max_amount as las_summ , loan_state as status_2_open_3_close
from 
(select microloan.client_id, microloan.date_schedule_payments_received as date_added,  substring(microloan.full_number for 4) as заключен, microloan.full_number, credit_product.name, client.lastname, client.firstname, client.secondname, microloan.loan_state, field_value.stringval, microloan.max_amount, contact.identifier, address.location_type, address.location, address.street, address.house, address.apartment
from client 
LEFT JOIN public.microloan ON microloan.client_id = client.id 
LEFT JOIN public.credit_product ON microloan.creditproduct_id = credit_product.id 
LEFT JOIN public.document ON microloan.client_id = document.client_id
LEFT JOIN public.field_value ON document.id = field_value.document_id
LEFT JOIN public.contact ON microloan.client_id = contact.client_id
LEFT JOIN public.address ON field_value.address_id = address.id

WHERE field_value.field_id = '117'
and contact.default_contact = 'TRUE'
and contact.type = '0'
and client.id > '77687'

GROUP BY microloan.client_id, microloan.date_schedule_payments_received, microloan.full_number, credit_product.name, client.lastname, client.firstname, client.secondname, microloan.loan_state, field_value.stringval, microloan.max_amount, contact.identifier, address.location_type, address.location, address.street, address.house, address.apartment
ORDER BY microloan.client_id DESC) as t

GROUP BY заключен, client_id, date_added, name, lastname, firstname, secondname, loan_state, stringval, max_amount, identifier
ORDER BY client_id LIMIT  100
