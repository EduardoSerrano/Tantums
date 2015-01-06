 #-*- coding: utf 8 -*-
import pooler
from report import report_sxw
import calendar
import datetime
import time
from datetime import datetime, date, time, timedelta

class ReportStatus(report_sxw.rml_parse):
    def __init__(self, cr, uid, name, context=None):
        super(ReportStatus, self).__init__(cr, uid, name, context=context)
        self.localcontext.update({
            'get_po': self.get_po,
            'get_date': self.get_date,
            'get_company_info': self.get_company_info,
        })

    def get_po(self,form):
        list_po=[]
        filtro = [('type', '=', 'in'),('state', '=', 'done'),('purchase_id','!=',None),('date_done','>=',str(form['form']['start_date'])+' 00:00:00'),('date_done','<=',str(form['form']['end_date'])+' 23:59:59')]

        if form['form']['purchase_id']:
            id_po = self.pool.get('stock.picking').search(self.cr, self.uid, [('purchase_id','=',form['form']['purchase_id'][0])])
            obj_po = self.pool.get('stock.picking').browse(self.cr, self.uid, id_po)
            for e in obj_po:
                list_po.append(e.purchase_id['id'])
            filtro.append(('purchase_id','in',list_po))

        id_origin = self.pool.get('stock.picking').search(self.cr, self.uid, filtro, order="origin")
        obj_origin = self.pool.get('stock.picking').browse(self.cr, self.uid,id_origin)

    	return obj_origin

    def get_date(self,date_done):
        date_time = None
        fecha = str(date_done)
        date_object = datetime.strptime(fecha[:10],'%Y-%m-%d')
        date_time = str(date_object)[:10]
        return date_time

    def get_company_info(self,form):
        company = self.pool.get('res.company').search(self.cr, self.uid,[('id','=',1)])
        company_obj= self.pool.get('res.company').browse(self.cr,self.uid,company)
        return company_obj


report_sxw.report_sxw('report.reportstock', 'report.stock.invoice', 'relation_purchase_invoice/reports/report_po_invoice.mako', parser = ReportStatus)