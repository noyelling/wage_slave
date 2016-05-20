require 'spec_helper'

describe WageSlave::BuildInvoices do

	let(:data) {{"ecocitydrivingschool@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"ecocitydrivingschool@gmail.com", "account_number"=>nil, "bsb"=>nil}], "zoran4drive@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"zoran4drive@gmail.com", "account_number"=>"585160295", "bsb"=>"084435"}], "craigwheeler09@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"craigwheeler09@gmail.com", "account_number"=>nil, "bsb"=>nil}], "amir@noyelling.com.au"=> [{"commission"=>"77.73", "net"=>"77.73", "gross"=>"77.73", "email"=>"amir@noyelling.com.au", "account_number"=>"529461886", "bsb"=>"014506"}], "mikestanley241@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"mikestanley241@gmail.com", "account_number"=>nil, "bsb"=>nil}], "justinmaherdrive@gmail.com"=> [{"commission"=>"77.73", "net"=>"77.73", "gross"=>"77.73", "email"=>"justinmaherdrive@gmail.com", "account_number"=>"10314743", "bsb"=>"064174"}], "mgb3777@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"mgb3777@gmail.com", "account_number"=>"10222701", "bsb"=>"065145"}, {"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"mgb3777@gmail.com", "account_number"=>"10222701", "bsb"=>"065145"}], "jmboyschau@gmail.com"=> [{"commission"=>"77.73", "net"=>"77.73", "gross"=>"77.73", "email"=>"jmboyschau@gmail.com", "account_number"=>nil, "bsb"=>nil}], "jo4nned23@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"jo4nned23@gmail.com", "account_number"=>"604043146", "bsb"=>"484799"}, {"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"jo4nned23@gmail.com", "account_number"=>"604043146", "bsb"=>"484799"}], "kevandrews0715@gmail.com"=> [{"commission"=>"49.09", "net"=>"49.09", "gross"=>"49.09", "email"=>"kevandrews0715@gmail.com", "account_number"=>"0139004", "bsb"=>"304190"}], "almatriplep@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"almatriplep@gmail.com", "account_number"=>"499892801", "bsb"=>"014506"}], "nikkomackintosh@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"nikkomackintosh@gmail.com", "account_number"=>"577713", "bsb"=>"734230"}], "edward.chivers59@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"edward.chivers59@gmail.com", "account_number"=>nil, "bsb"=>nil}], "robertkosho@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"robertkosho@gmail.com", "account_number"=>"906057871", "bsb"=>"014018"}], "dougsdrivinglessons@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"dougsdrivinglessons@gmail.com", "account_number"=>"20592207", "bsb"=>"124083"}], "distinctiondrivingschool@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"distinctiondrivingschool@gmail.com", "account_number"=>"510471", "bsb"=>"734089"}], "rohdrive1007@gmail.com"=> [{"commission"=>"47.73", "net"=>"47.73", "gross"=>"47.73", "email"=>"rohdrive1007@gmail.com", "account_number"=>nil, "bsb"=>nil}]}}
	let(:params) {
		{
			item_description: "No Yelling Commission",
			due_date: Date.today,
			item_quantity: 1,
			account_code: 240
		}
	}

	it "must be a class" do
		WageSlave::BuildInvoices.must_be_instance_of Class
	end

	it "will build an array of Xeroizer Invoice Objects" do

    WageSlave.configure do | config |
      config.xero = {
        consumer_key: "test",
        consumer_secret: "test",
        pem_file_location: "test",
      }
    end

		payments = WageSlave::BuildInvoices.new(data)
		xero_invoices = payments.build_invoices(params[:item_description], params[:due_date], params[:item_quantity], params[:account_code])
		xero_invoices.must_be_instance_of Array
	end

end
