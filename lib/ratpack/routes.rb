module RatPack
  module Routes
    def subdomains(tld_len=1) # we set tld_len to 1, use 2 for co.uk or similar
      subdomain_regex = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/  
      @subdomains ||= if (request.host.nil? ||subdomain_regex.match(request.host))
                        request.host.split('.')[0...(1 - tld_len - 2)]
                      else
                        []
                      end
    end
  end
end