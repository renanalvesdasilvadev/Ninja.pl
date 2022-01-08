package V1::Foo::CreateFooService;
{
    use V1::Foo::CreateFooRequestDTO;
    use Exception;
    use StatusCodeBadRequest;
    use StatusCodeOK;
    use JSON;
    
    sub new {
        my ( $class, $fooRepository ) = @_;
        my $self = {
            "fooRepository" => $fooRepository
        };
        bless $self, $class;
        return $self;
    }

    sub execute {
        my ($self, $payload) = @_;

        my $requestDTO = V1::Foo::CreateFooRequestDTO->new();
                
        $requestDTO->setValues($payload);
        my @messages = $requestDTO->validate;
        
        if(scalar @messages > 0){       
            return V1::StatusCodeBadRequest::response (encode_json \@messages);            
        }           

        my $id = $self->{"fooRepository"}->create($payload);

        my $payload = {
            "id" => $id
        };

        return V1::StatusCodeOK::response(encode_json $payload);

    }

}
1;