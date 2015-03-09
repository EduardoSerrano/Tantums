<html>
<head>
<style type="text/css">
	${css} 
</style>
</head>
<body>
<% setLang(user.lang) %>
<div>
		<div>
				<div>
		%if get_move_lines(data):
					${helper.embed_image('jpeg',str(get_move_lines(data)[0].company_id.logo_web),250, 120)}

				</div>
			<h3 class="title">
				${_('ACCOUNT SIMPLE STATEMENT REPORT') | entity}
				
			</h3>
			<h5>
				<div align="center">
					<p>${_('FROM :')}${formatLang(data['form']['date_start'],date=True) | entity }${_('  TO :')}${formatLang(data['form']['date_finish'],date=True) | entity}</p>
				</div>
		
			</h5>
		</div>
</div>

<table width="100%" style="font-size:10px; font-weight: bold;">
					<tr width="100%">
						<td colspan="1">${_('Name       :')}</td>
						<td colspan="3">${get_move_lines(data)[0].partner_id.name}</td>	
						<td colspan="4"></td>
					</tr>
					<tr width="100%">
						<td colspan="1">${_('Address    :')}</td>
						<td colspan="3">${get_move_lines(data)[0].partner_id.street}</td>
						<td colspan="4"></td>
					</tr>
					<tr width="100%">
						<td colspan="1"></td>
						<td colspan="3">${get_move_lines(data)[0].partner_id.l10n_mx_street3}</td>
						<td colspan="4"></td>
					</tr>
					<tr width="100%">
						<td colspan="1"></td>
						<td colspan="3">${get_move_lines(data)[0].partner_id.street2}</td>
						<td colspan="4"></td>
					</tr>
					<tr width="100%">
						<td colspan="1">${_('City       :') or ' '}</td>
						<td colspan="2">${get_move_lines(data)[0].partner_id.city_id.name}</td>
						<td colspan="1">${_('State       :')}</td>
						<td colspan="2">${get_move_lines(data)[0].partner_id.state_id.name}	</td>
						<td colspan="1">${_('Zip       :')}</td>
						<td colspan="1">${get_move_lines(data)[0].partner_id.zip}</td>
					</tr>
					<tr>
						<td width="12.5%" align='center'>
							${_('Document Date') | entity}	
						</td>
						<td width="12.5%" align='center'>
							${_('Document') | entity}
						</td>
						<td width="12.5%" align='center'>
							${_('Due Date') | entity}
						</td>
						<td width="12.5%" align='center'>
							${_('Journal') | entity}
						</td>
						<td width="12.5%" align='center'>
							${_('Currency') | entity}
						</td> 
						<td width="12.5%" align='center'>
							${_('Credit') | entity}
						</td>
						<td width="12.5%" align='center'>
							${_('Debit') | entity}
						</td>
						<td width="12.5%" align='center'>
							${_('Current Balance') | entity}
						</td>
					</tr>
			%endif
					<tr>
    					<td colspan="8" align="right">
    						<font size='1'>
    				 			${_(' Last Balance') | entity} : ${formatLang(get_last_balance(data),monetary=True) or 0.00}
    				 		</font>
    				 	</td>
    				</tr>
</table>
    		
% for o in 	get_move_lines(data):
<table  width="100%">	
				%if (o.credit > 0):
					<tr>
							<td width="12.5%" align='center'>
								<font size="1">
									</div>${formatLang(o.date,date=True) | entity }</div>
								</font>
							</td>
							<td width="12.5%" align='center' style="font-zise:small;">
								<font size="1">
									${o.name}
								</font>
							</td>
							<td width="12.5%" align='center'>
								<font size="1">
								%if o.date_maturity: 
									${formatLang(o.date_maturity,date=True) | entity }
								%endif
								</font>
							</td>
							<td  width="12.5%" align='center'>
								<font size="1">
									${o.journal_id.code}
								</font>
							</td>
							<%import datetime%>
							<%now = datetime.datetime.now()%>
							<td width="12.5%" align='left'>
								<font size="0">
						%if o.journal_id.currency:
									${o.journal_id.currency.name}
									${_('TC:')}${"{0:.2f}".format(1/get_tc(o.journal_id.currency.id,now.strftime('%Y-%m-%d')))}
									<br>
									${'REF:'}${formatLang(o.credit,monetary=True)}
						%endif

								</font>
							</td>
							<td width="12.5%" align='center'>
								<font size="1">
						%if o.journal_id.currency:
									${formatLang(o.credit/get_tc(o.journal_id.currency.id,now.strftime('%Y-%m-%d')),monetary=True)}
						%else:
									${formatLang(o.credit,monetary=True)}
						%endif
						
								</font>
							</td>
							<td width="12.5%" align='center'>
								<font size="1">
								</font>

							</td>
							<td width="12.5%" align='center'>
								<font size="1">
								</font>		  	
							</td>
					</tr>
				%endif
				%if (o.debit > 0):
					 <tr>
						<td width="12.5%" align='center'>
							<font size="1">
								${formatLang(o.date,date=True)}
							</font>
						</td>
						<td width="12.5%" align='center'>
							<font size="1">
						    	${o.ref}
						    </font>
						</td>	
						<td width="12.5%" align='center'>
							##${payments_obj}
						</td>
						<td  width="12.5%" align='center'>
							<font size="1">
								${o.journal_id.code}
							</font>
						</td>	
						<td width="12.5%" align='center'>
							##${o.currency_id.name}
						</td>
						<td width="12.5%" align='center'>
							
						</td>
						<td width="12.5%" align='center'>
							<font size="1">
								${formatLang(o.debit,monetary=True)}
							</font>
						</td>
						</td>
						<td width="12.5%" align='center'>
							 ##${formatLang(residual,monetary=True)} 
						</td>
					</tr>
				%endif
%endfor
				<div style="font-size:10px; font-weight: bold;">
    				<tr>
	    				<td  colspan="3" align="left">
	    					<font size="1">
	    			%if data['form']['mov_type'] == 'in_invoice':
							<div width='12.5%'>${_('Charges')}${' : '}${formatLang(get_total_debit_credit(get_move_lines(data))['sum_tot_credit']) or '0.00' |entity}</div>
					%else:
							<div width='12.5%'>${_('Charges')}${' : '}${formatLang(get_total_debit_credit(get_move_lines(data))['sum_tot_debit']) or '0.00' |entity}
					%endif
							</font>
						</td>
						<td  colspan="3" align="right">
							<font size="1">
					%if data['form']['mov_type'] == 'in_invoice':
								${_('Payments')}${' : '}${formatLang(get_total_debit_credit(get_move_lines(data))['sum_tot_debit']) or '0.00' |entity}
					%else:
								${_('Receipts')}${' : '}${formatLang(get_total_debit_credit(get_move_lines(data))['sum_tot_credit']) or '0.00' |entity}
					%endif
							</font>
						</td>
						<td  colspan="2" align="right">
							<font size="1">
					%if data['form']['mov_type'] == 'in_invoice':
								${_('Balance')}${' : '}${formatLang((get_last_balance(data) + get_total_debit_credit(get_move_lines(data))['sum_tot_credit'])- get_total_debit_credit(get_move_lines(data))['sum_tot_debit'],monetary=True) or '0.00' |entity}
					%else:
								${_('Balance')}${' : '}${formatLang((get_last_balance(data) + get_total_debit_credit(get_move_lines(data))['sum_tot_debit'])- get_total_debit_credit(get_move_lines(data))['sum_tot_credit'],monetary=True) or '0.00' |entity}
					%endif

							</font>
						</td>
					</tr>
				</div>

		</table>
			
<p style="page-break-before: always;"></p>
</body>
</html>