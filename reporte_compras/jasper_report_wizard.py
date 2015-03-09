# -*- coding: utf-8 -*-
##############################################################################
import time
import calendar
import datetime
from openerp.osv import fields, osv
from openerp import netsvc
from datetime import date

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
		date_start = self.browse(cr,uid,ids[0]).start_date
		fecha_inicial = date_start.split('-')
		date_end = self.browse(cr,uid,ids[0]).end_date
		fecha_final = date_end.split('-')
		months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
		fecha_start = fecha_inicial[2] + " " + months[int(fecha_inicial[1]) - 1] + " " + fecha_inicial[0]
		fecha_end =  fecha_final[2] + " " + months[int(fecha_final[1]) - 1] + " " + fecha_final[0]
		query ="where a.type = 'in' and a.state = 'done' and a.date_done >= to_timestamp($P{start_date}, 'DD Mon YYYY') and a.date_done <= to_timestamp($P{end_date}, 'DD Mon YYYY')"
		if self.browse(cr,uid,ids[0]).product_id.id:
			query = query + " and c.product_id = " + str(self.browse(cr,uid,ids[0]).product_id.id)
		if self.browse(cr,uid,ids[0]).partner_id.id:
			query = query + " and b.partner_id = " + str(self.browse(cr,uid,ids[0]).partner_id.id)
		if self.browse(cr,uid,ids[0]).warehouse_id.id:
			query = query + " and b.warehouse_id = " + str(self.browse(cr,uid,ids[0]).warehouse_id.id)
		query = query + " order by a.purchase_id"
		data={}
		data['model']='reporte.compras.wizard.xls'
		data['ids']=ids
		data['origin_records']=False
		data.update({'parameters':{
			'report_title':"Reporte Compras",
			'start_date':str(fecha_start),
			'end_date':str(fecha_end),
			'query':str(query)
			}
			})
		
		r= {
		'type':'ir.actions.report.xml',
		'report_name':'jasper_reporte_compras_xls',
		'datas':data
		}

		return r
		
product_report_stock_wizard()