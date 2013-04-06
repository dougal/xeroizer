module Xeroizer
  module Record
    
    class AccountModel < BaseModel
        
      set_permissions :read
        
    end
    
    class Account < Base
    
      TYPE = {
        'BANK' =>           '',
        'CURRENT' =>        '',
        'FIXED' =>          '',
        'PREPAYMENT' =>     '',
        'EQUITY' =>         '',
        'DEPRECIATN' =>     '',
        'DIRECTCOSTS' =>    '',
        'EXPENSE' =>        '',
        'OVERHEADS' =>      '',
        'CURRLIAB' =>       '',
        'LIABILITY' =>      '',
        'TERMLIAB' =>       '',
        'OTHERINCOME' =>    '',
        'REVENUE' =>        '',
        'SALES' =>          ''
      } unless defined?(TYPE)

      TAX_TYPE = {
        'NONE' =>             'No GST',
        'EXEMPTINPUT' =>      'VAT on expenses exempt from VAT (UK only)',
        'INPUT' =>            'GST on expenses',
        'SRINPUT' =>          'VAT on expenses',
        'ZERORATEDINPUT' =>   'Expense purchased from overseas (UK only)',
        'RRINPUT' =>          'Reduced rate VAT on expenses (UK Only)', 
        'EXEMPTOUTPUT' =>     'VAT on sales exempt from VAT (UK only)',
        'OUTPUT' =>           'OUTPUT',
        'OUTPUT2' =>          'OUTPUT2',
        'SROUTPUT' =>         'SROUTPUT',
        'ZERORATEDOUTPUT' =>  'Sales made from overseas (UK only)',
        'RROUTPUT' =>         'Reduced rate VAT on sales (UK Only)',
        'ZERORATED' =>        'Zero-rated supplies/sales from overseas (NZ Only)',
        'ECZROUTPUT' =>       'Zero-rated EC Income (UK only)'
      } unless defined?(TAX_TYPE)
      
      set_primary_key :account_id
            
      guid    :account_id
      string  :code
      string  :name
      string  :type
      string  :class, :internal_name => :account_class
      string  :status
      string  :currency_code
      string  :tax_type
      string  :description
      string  :system_account
      boolean :enable_payments_to_account
      boolean :show_in_expense_claims
      string  :bank_account_number
      string  :reporting_code
      string  :reporting_code_name
      
      # override from xml helper so we can get the correct node depending on whether it's BankAccount or not
      def to_xml(b = Builder::XmlMarkup.new(:indent => 2))
        optional_root_tag(parent.class.optional_xml_root_name, b) do |b|
          b.tag!(self.type == 'BANK' ? 'BankAccount' : (parent.class.xml_node_name || parent.model_name)) { 
            attributes.each do | key, value |
              field = self.class.fields[key]
              value = self.send(key) if field[:calculated]
              xml_value_from_field(b, field, value) unless value.nil?
            end
          }
        end
      end
    end
    
  end
end
