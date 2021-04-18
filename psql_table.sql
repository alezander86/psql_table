select DISTINCT on (t1.client_id) pasport, inn
from
(select microloan.client_id, field_value.stringval as pasport
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
and field_value.field_id in ('1')
and default_contact = 'TRUE'

GROUP BY date_added, microloan.client_id, pasport
ORDER BY microloan.client_id) as t1,


(select microloan.client_id, field_value.stringval as inn
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

GROUP BY date_added, microloan.client_id, inn
ORDER BY microloan.client_id) as t2

WHERE t1.client_id = t2.client_id

GROUP BY t1.client_id, inn, pasport