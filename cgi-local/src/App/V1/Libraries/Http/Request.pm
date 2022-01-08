package V1::Request;
{
    use CGI;
    use JSON;
    use Try::Tiny;
    
    sub getParams {

        my $cgi = new CGI;

        my $parameters = {};

        my @names = $cgi->param;
        
        foreach my $name (@names){
            if( $name =~ /\_/ ){
                next;
            } else {
                $parameters->{$name} = $cgi->param($name);
            }
        }

        $bodydata = $cgi->param($cgi->request_method()."DATA");

        if($bodydata ne undef){

            delete($parameters->{$cgi->request_method()."DATA"});
            
            try 
            {
                $bodydata = decode_json $bodydata;

                foreach my $key (keys $bodydata){
                    
                    $parameters->{$key} = $bodydata->{$key};
                    
                }                

            } catch {
                
            }

        }
        
        return $parameters;
    }
}
1;