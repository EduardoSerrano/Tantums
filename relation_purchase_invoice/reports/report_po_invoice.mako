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
    % for o in get_company_info(data):
    <div>${helper.embed_image('jpeg',str(o.logo_web),250, 120)}</div>
    % endfor
    <%e = None %>
    </td>
    </tr>
        <tr>
            <th style='min-width:80%; font-size:12pt' colspan="9" align="center">Relacion Compra Factura</th>
        </tr>
    </table>
    %for o in get_po(data):
    %if e != o.purchase_id.name:
    <table class='table' width="100%" cellspacing="0" cellpadding="3px" style="font-size:13px">
        <tr>
            <td colspan="12" style="border-bottom:5px double #000;"></td>
        </tr>
        <tr id="header2">
            <th align="left" width="20%">${get_date(o.date_done)}</th>
            <th align="center" width="40%">${o.purchase_id.name}</th>
            <th align="left" width="30%">${formatLang(o.purchase_id.amount_total) or '0.00' }</th>
            <th align="left" width="10%"> Estado De Factura </th>
        <%e = o.purchase_id.name %>
        </tr>
                <tr class="subhead">
                %for f in o.purchase_id.invoice_ids:
                <table width="100%" cellpadding="3px" style="font-size:13px">
                    %if f.state == 'draft':
                    %if f.date_invoice:
                    <td align="left" width="20%">${f.date_invoice}</td>
                    %else:
                    <td align="left" width="20%">No Existe Fecha </td>
                    %endif
                    %if f.number:
                    <td align="center" width="40%">${f.number}</td>
                    %else:
                    <td align="center" width="40%">No Existe Factura </td>
                    %endif
                    <td align="left" width="30%" >${formatLang(f.amount_total) or '0.00' }</td>
                    <td align="left" width="10%"> Borrador </td>
                    %endif
 
                    %if f.state == 'open':
                    <td align="left" width="20%">${f.date_invoice}</td>
                    <td align="center" width="40%">${f.number}</td>
                    <td align="left" width="30%" >${formatLang(f.amount_total) or '0.00' }</td>
                    <td align="left" width="10%"> Abierto </td> 
                    %endif

                    %if f.state == 'paid':
                    <td align="left" width="20%">${f.date_invoice}</td>
                    <td align="center" width="40%">${f.number}</td>
                    <td align="left" width="30%" >${formatLang(f.amount_total) or '0.00' }</td>
                    <td align="left" width="10%"> Pagado </td> 
                    %endif
                    </table>
                    %endfor
                    <br>
                    %endif
                    %endfor
                </table>
                </tr>
            <br>
    </table>
    <br>
    <br>
    </body>
    </html>