--Amortización Bonos Canje
select trunc(fecha, 'MM') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje in (202, 103)
AND c32a_moneda = 'USD'
AND campo2 = '001'
AND  campo3 in ('661', '662', '663')
AND  c20 NOT like 'SISVAL%'
group by trunc(fecha, 'MM'), codigo_mensaje
order by 1,2;

--Intereses Bonos Canje
select trunc(fecha, 'DD') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje = 103
AND (
    ( campo2 = '027' AND c32a_moneda = 'USD' AND campo3 in ('127', '227', '327', '427', '527'))
    OR
    (campo2 = '001' AND campo3 in ('661', '662', '663') AND c32a_moneda = 'USD' AND c20 like 'SISVAL%'))
group by trunc(fecha, 'DD'), codigo_mensaje
order by 1,2;

--Intereses Bono Externo
select trunc(fecha, 'MM') mes, campo4, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje = 202
AND campo2 = '001'
AND campo3 = '790'
AND c32a_moneda = 'USD'
--     campo4 ='MEF4 20300710UYU-24(I1) '
group by trunc(fecha, 'MM'), campo4
order by 1,2;


--Emision de Notas en UI
select trunc(fecha, 'MM') mes, campo4, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje = 202
     campo2  está vacío pero código transacción es 6 no hay subtipo muestra cuenta en UI
     campo3  repitió campo2
     campo1 idem campo2 y campo3
AND campo2 = '001'
AND campo3 = '790'
AND c32a_moneda = 'USD'
AND campo1 like '%/CODTYPTR/006%'
AND campo1 like '%/ISSUE/ISIN%UI%'
group by trunc(fecha, 'MM'), campo4
order by 1,2;


--Deuda MEF BHU
-- Amortizaciones --> campo1 código 901 trae el monto
-- Intereses      --> campo1 código 902 trae el monto
select trunc(fecha, 'MM') mes, campo1, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje = 202
AND campo2 = '001'
AND campo3 = '794'
AND c32a_moneda = 'USD'
group by trunc(fecha, 'MM'), campo1
order by 1,2;


-- Gastos Bonos
-- la separación que hacen por calificadora (Fitch, Moody) y gastos bonos es por el campo4 
select trunc(fecha, 'MM') mes, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje = 202
AND campo2 = '001'
AND campo3 = '793'
AND c32a_moneda = 'USD'
group by trunc(fecha, 'MM')
order by 1,2;

-- Prestamos Internacionales
-- Febrero no cierra el día 15/02/2019, pero no se que movimientos tomaron. El resto de los días esta OK
-- El que viene como crédito el 15/02/2019, (en la tabla spbcu.movimientos_detalle esta como crédito) en el campo 72 tiene lo siguiente: 
--        /CODTYPTR/001/002
--        //BID 1407 PAGO VTO
--
select trunc(fecha, 'DD') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje IN (202, 103)
AND campo2 = '001'
AND campo3 = '700'
AND c32a_moneda = 'USD'
group by trunc(fecha, 'DD'),codigo_mensaje
order by 1,2;


-- Transferencia Cta. Euros
select trunc(fecha, 'MM') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje IN (202, 103)
AND campo1 like '/CODTYPTR/030%'
AND c32a_moneda = 'USD'
group by trunc(fecha, 'MM'),codigo_mensaje
order by 1,2;


-- Transferencia Cta. Bono 2022 y 2055
-- del campo 53D del mensaje swift se puede obtener la cuenta origen.
select trunc(fecha, 'MM') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje IN (202, 103)
AND campo2 = '001'
AND campo3 = '004'
AND c32a_moneda = 'USD'
AND swift like '%SA0751USD%'
group by trunc(fecha, 'MM'),codigo_mensaje
order by 1,2;

-- Transferencia BROU (Febrero)
select trunc(fecha, 'MM') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje IN (202, 103)
AND campo2 = '001'
AND campo3 = '001'
AND swift like '%SA0751USD%'
AND c32a_moneda = 'USD'
group by trunc(fecha, 'MM'),codigo_mensaje
order by 1,2;

-- Venta Energía
select trunc(fecha, 'MM') mes, codigo_mensaje, sum(c32a_monto)
from spbcu.mensajes_out_72 
where fecha between TO_DATE('01/01/2019', 'DD/MM/YYYY') AND TO_DATE('28/02/2019', 'DD/MM/YYYY') 
AND codigo_mensaje IN (202, 103)
AND campo2 = '001'
AND campo3 = '002'
AND c20 like '%CTM%'
AND swift like '%SA0751USD%'
AND c32a_moneda = 'USD'
group by trunc(fecha, 'MM'),codigo_mensaje
order by 1,2;


-- SWAP
-- Febrero no cierra el día 15/02/2019, pero no se que movimientos tomaron. 
--En sw no va nada porque es ficticio.
