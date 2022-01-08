package V1::AuthenticateMiddleware;
{
    use StatusCodeForbidden;
    use StatusCodeUnauthorized;
    use JSON;

    sub new {
        my ($self) = @_;   

        return bless {};
    }

    sub execute {
        $self = $_[0];
        $payload = $_[1];
        
        return {
            "property" => "teste",
            "value"    => "teste"
        };
    }
}
1;