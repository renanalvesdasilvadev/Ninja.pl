#!/usr/bin/perl

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use Try::Tiny;

#rever autoload

#autoload
BEGIN{    
    push @INC, "./src/App/";
    push @INC, "./src/App/V1/Libraries/";
    push @INC, "./src/App/V1/Libraries/Http/";
    push @INC, "./src/App/V1/Libraries/Util/";
    push @INC, "./src/App/V1/Libraries/Exception/";
    push @INC, "./src/App/V1/Libraries/Type/";
    push @INC, "./src/App/V1/Libraries/Type/Validators/";
    push @INC, "./src/App/V1/Libraries/StatusCode/";
}
#--autoload

use Url;
use Request;
use Response;
use Exception;
use RootModule;

$cgi = new CGI;
$uri = V1::Url::getRequestURI;
$verb = lc($cgi->request_method());
$params = V1::Request::getParams;
$rootModule = RootModule->new();

my $response = $rootModule->executeRouteMethod($verb, $uri, $params);
V1::Response::handle($response);


#Upload de arquivos