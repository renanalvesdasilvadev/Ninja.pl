package V1::Response;
{

    use CGI;
    use JSON;    
    use V1::Libraries::Util::Comparator;

    my $cgi = new CGI;

    sub handle {     

        my $payload = $_[0];

        my $code = $payload->{"code"};
        my $message = $payload->{"message"};
        my $contenttype = V1::Comparator::isJson($message) ? "application/json" : "text/html";  

        print $cgi->header(
            -charset => 'ISO 8859-1',
            -status => $code,            
            -type => $contenttype
        );          
        
        print $message;
    }
}
1;