<html>
<head>
<style>
.table
    {
    font-size:10px;d
    }
     
#header2 th
    {
    border-bottom:1px solid #000;
    }
.total1 td
    {
    border-top:1px dashed #000;
    }
.total2 td
    {
    border-top:2px solid #000;
    }
.subhead td
    {
    border-bottom:1px solid #D1D1D1;
    }
     
.sign td
    {
    font-size:8px;
    border:1px solid #000;
    }
     
table, td, th
    {
    border-collapse:collapse;
    }
     
</style>
</head>
<body>
    <table width="100%">
    <tr>
    <td>
    %for m in get_money():
    ${helper.embed_image('jpeg',str(get_logo()[0].logo),180, 85)}
    <% total = 0 %>
    </td>
    </tr>
        <tr>
            <th style='min-width:80%; font-size:12pt' colspan="9" align="center">Reporte De Compras de <p>${formatLang(data['form']['start_date'],date=True) | entity }${_('  A  :')}${formatLang(data['form']['end_date'],date=True) | entity}</p></th>
        </tr>
    </table>
    <table class='table' width="100%" cellspacing="0" cellpadding="3px">
        <tr>
            <td colspan="12" style="border-bottom:5px double #000;"></td>
        </tr>
        <tr id="header2">
            <th align="left" width="5%">Planta</th>
            <th align="left" width="10%">Fecha</th>
            <th align="left" width="15%">Provedor</th>
            <th align="left" width="10%">Orden de Compra </th>
            <th colspan="5" width="60%"><table width="100%" cellspacing="100"><tr>
            <th align="left" width="20%">Concepto</th>
            <th align="center" width="10%">Cantidad </th>
            <th align="center" width="10%">Unidad De Medida </th>
            <th align="center" width="10%">Precio Unitario </th>
            <th align="center" width="20%">Tipo De Cambio </th>
            <th align="center" width="10%">Precio Sin IVA</th>
            </tr>
            </table>
        </tr>
    
        %for o in get_result(data)['invoice_obj']:
        <tr class="subhead">
                <td align="left" width="5%">${o.purchase_id.warehouse_id.name}</td>
                <td align="left" width="10%">${get_date(o.date_done)}</td>
                <td align="left" width="15%">${o.partner_id.name}</td>
                <td align="left" width="10%">${o.purchase_id.name}</td>
                <td colspan ="5" width="60%"><table width="100%" cellspacing="100">
        <tr>

            %if get_result(data)['Insumos']:
                %for i in get_stock_move(o.id,get_result(data)['Insumos']):
                <td align="left" width="20%">${i.name}</td>
                <td align="center" width="10%">${i.product_qty}</td>
                <td align="center" width="10%">${i.product_uom.name}</td>
                <td align="center" width="10%">${i.price_unit}</td>
                %if o.purchase_id.pricelist_id.currency_id.name == m.name:
                    <td align="center" width="20%">${m.name}</td>
                %else:
                    <td align="center" width="20%">${o.purchase_id.pricelist_id.currency_id.name}<br>
                    ${1/float(get_tc(o.purchase_id.pricelist_id.currency_id.id,o.date_done))}
                %endif
                <% TC = 1/float(get_tc(o.purchase_id.pricelist_id.currency_id.id,o.date_done))%>
                <% a = i.price_unit * i.product_qty %>
                <%sub = a * TC %>
                <% total = total + sub %>
                <td align="center"  width="10%">$ ${formatLang(sub) or '0.00'}</td>
                </tr>
                %endfor

            %elif not get_result(data)['Insumos']:
                %for i in o.move_lines:
                <td align="left" width="20%">${i.name}</td>
                <td align="center" width="10%">${i.product_qty}</td>
                <td align="center" width="10%">${i.product_uom.name}</td>
                <td align="center" width="10%">${i.price_unit}</td>
                %if o.purchase_id.pricelist_id.currency_id.name == m.name:
                    <td align="center" width="20%">${m.name}</td>
                %else:
                    <td align="center" width="20%">${o.purchase_id.pricelist_id.currency_id.name}<br>
                    ${1/float(get_tc(o.purchase_id.pricelist_id.currency_id.id,o.date_done))}
                %endif
                <% TC = 1/float(get_tc(o.purchase_id.pricelist_id.currency_id.id,o.date_done))%>
                <% a = i.price_unit * i.product_qty %>
                <% sub = a * TC %>
                <% total = total + sub %>
                <td align="center"  width="10%">$ ${formatLang(sub) or '0.00'}</td>
                </tr>
                %endfor
            %endif
            
                    </table>
                </tr>
            %endfor
    </table>
    %endfor
    <br>
    <h3><b><p align="right">Total:$ ${formatLang(total) or '0.00'} </p></b></h3>
    <br/>
    <br/>
</body>
</html>