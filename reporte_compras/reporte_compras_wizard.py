# -*- coding: utf 8 -*-
import time
import calendar
import datetime
from openerp.osv import fields, osv
from openerp import netsvc

class reporte_compras_wizard(osv.osv_memory):
	_name = 'reporte.compras.wizard'
	_columns = {
	'product_id': fields.many2one('product.product', string="Insumos",),
	'warehouse_id': fields.many2one('stock.warehouse', string="Planta"),
	'partner_id': fields.many2one('res.partner',domain=[('supplier','=',True)], string="Proveedor"),
	'start_date': fields.date(string="Fecha Incial",required=True),
	'end_date': fields.date(string="Fecha Final",required=True),
	}

	_defaults = {
	'start_date': lambda *a: datetime.date.today().strftime('%Y-%m-01'),
	'end_date': lambda *a: datetime.date.today().strftime('%Y-%m-%d'),
	}

	def print_report(self,cr,uid,ids,context=None):
		#OBTENER EL WIZARD
		datas = {}
		datas = {'ids': context.get('active_ids', [])}
		datas['model'] = 'reporte.compras.wizard'
		datas['form'] = self.read(cr, uid, ids)[0]

		return {
			'type': 'ir.actions.report.xml',
			'report_name': 'purchase',
			'datas':datas,
			'context': context,
		}
		