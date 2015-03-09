from openerp.osv import fields, osv

class res_partner(osv.osv):
    
    _inherit = 'res.partner'
    
    def get_invoices_details_dict(self, cr, uid, ids, date_start, date_end, context={}):
        
        invoice_details = []
        values_partner = {}

        for partner_id in ids:
            partner_obj = self.pool.get('res.partner').browse(cr, uid, partner_id)
            search_domain = [('partner_id','=',partner_id),('state','not in',('draft','cancel'))]
            if date_start:
                search_domain.append(('date_invoice','>=',date_start))
            if date_end:
                search_domain.append(('date_invoice','<=',date_end))
            
            partner_invoice_ids = self.pool.get('account.invoice').search(cr, uid, search_domain)
            values_partner = {
                'name' : partner_obj.name,
                'partner_id' : partner_id,
                'email' : partner_obj.email,
                'invoices' : []
            }
            invoice_details.append(values_partner)
            list_invoices = []
            values_invoice = {}
            
            for partner_invoice_id in partner_invoice_ids:
                payment_ids = self.pool.get('account.invoice').read(cr, uid, [partner_invoice_id], ['payment_ids'])[0]['payment_ids']
                invoice_obj = self.pool.get('account.invoice').browse(cr, uid, partner_invoice_id)
                values_invoice = {
                    'amount_total' : invoice_obj.amount_total,
                    'number' : invoice_obj.number,
                    'state' : invoice_obj.state,
                    'payments' : []
                }
                list_invoices.append(values_invoice)
                list_payments = []
                for payment_id in payment_ids:
                    payment_obj = self.pool.get('account.move.line').browse(cr, uid, payment_id)
                    move_id = payment_obj.move_id.id
                    voucher_ids = self.pool.get('account.voucher').search(cr, uid, [('move_id','=',move_id)])
                    values_payment = {}
                    for voucher_id in voucher_ids:
                        voucher_obj = self.pool.get('account.voucher').browse(cr, uid, voucher_id)
                        values_payment = {
                            'number' : voucher_obj.number,
                            'amount' : payment_obj.credit
                        }
                        list_payments.append(values_payment)
                values_invoice['payments'] = list_payments
            values_partner['invoices'] = list_invoices
        
        return  invoice_details
res_partner()