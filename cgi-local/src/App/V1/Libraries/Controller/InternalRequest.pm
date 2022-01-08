package V1::InternalRequest;
{
    use RootModule;

    sub execute {
        my ($verb, $uri, $payload) = @_;
        
        my $rootModule = RootModule->new();

        return $rootModule->executeRouteMethod($verb, $uri, $params);
    }
}
1;