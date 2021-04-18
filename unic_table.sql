select DISTINCT on (client_id) заключен, lastname, firstname, secondname, identifier as telephone, office, name as packet_name , stringval as inn, max_amount as las_summ , date_added as последний , loan_state as status_2_open_3_close, location_type, location, street, house, apartment
from 
( select microloan.client_id, date_added, substring (microloan.full_number for 4) as заключен, office.name_short as office, microloan.full_number, credit_product.name, client.lastname, client.firstname, client.secondname, operation.type, microloan.loan_state, field_value.stringval, microloan.max_amount, contact.identifier, address.location_type, address.location, address.street, address.house, address.apartment
from operation 
LEFT JOIN public.microloan ON operation.loan_id = microloan.id 
LEFT JOIN public.client ON microloan.client_id = client.id 
LEFT JOIN public.credit_product ON microloan.creditproduct_id = credit_product.id 
LEFT JOIN public.office ON operation.office_id = office.id
LEFT JOIN public.document ON microloan.client_id = document.client_id
LEFT JOIN public.field_value ON document.id = field_value.document_id
LEFT JOIN public.contact ON microloan.client_id = contact.client_id
LEFT JOIN public.address ON field_value.address_id = address.id

WHERE date_added = (SELECT MAX(date_added) FROM operation WHERE operation.loan_id  = microloan.id 
and substring (microloan.full_number for 4) = 'ДОДБ')
and field_value.field_id in ('119')
and default_contact = 'TRUE'


GROUP BY date_added, microloan.client_id, office, microloan.full_number, credit_product.name, client.lastname, client.firstname, client.secondname, operation.type, microloan.loan_state, field_value.stringval, microloan.max_amount, contact.identifier, address.location_type, address.location, address.street, address.house, address.apartment
ORDER BY microloan.client_id DESC) as t 

GROUP BY заключен, client_id, date_added, office, name, lastname, firstname, secondname, loan_state, stringval, max_amount, identifier, location_type, location, street, house, apartment

ORDER BY client_id, max(date_added) DESC