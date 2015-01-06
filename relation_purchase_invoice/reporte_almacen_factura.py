# -*- coding: utf 8 -*-
from osv import fields, osv
from openerp import netsvc

class report_stock_wizard(osv.osv_memory):
	_name = 'report.stock.invoice'
	_columns = {
	'purchase_id': fields.many2one('purchase.order', string="Orden De Compra"),
	'start_date': fields.date(string="Fecha Incial",required=True),
	'end_date': fields.date(string="Fecha Final",required=True),
	}

	def print_report(self,cr,uid,ids,context=None):
		#OBTENER EL WIZARD
		datas = {}
		datas = {'ids': context.get('active_ids', [])}
		datas['model'] = 'report.stock.invoice'
		datas['form'] = self.read(cr, uid, ids)[0]

		return {
			'type': 'ir.actions.report.xml',
			'report_name': 'reportstock',
			'datas':datas,
			'context': context,
		}
		