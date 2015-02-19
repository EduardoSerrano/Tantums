# -*- coding: utf-8 -*-
##############################################################################
import time
import calendar
import datetime
from openerp.osv import fields, osv
from openerp import netsvc

class product_report_stock_wizard(osv.osv_memory):
	_name = 'reporte.compras.wizard.xls'
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
		data={}
		data['model']='reporte.compras.wizard.xls'
		data['ids']=ids
		data['origin_records']=False
		if product_id 
		data.update({'parameters':{
			'report_title':"Reporte Compras",
			'product_id':self.browse(cr,uid,ids[0]).product_id.name
			}
			})
		r= {
		'type':'ir.actions.report.xml',
		'report_name':'jasper_reporte_compras_xls',
		'datas':data
		}
		return r

product_report_stock_wizard()