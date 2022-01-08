package V1::Foo::FooController;
{    
    use V1::Foo::FooProviders;

    use constant USE_DEPENDENCY_INJECTION => 1;
    use constant DEPENDENCIES_PROVIDERS => [
        V1::Foo::FooProviders::CREATE_FOO_SERVICE_PROVIDER
    ];
    sub new {
        my ($class, $createFooService) = @_;
        
        return bless {
            "createFooService" => $createFooService
        }, $class;
    }

    sub createFoo {
        my ($self, $payload) = @_;
    
        return $self->{"createFooService"}->execute($payload);
    }
    
}
1;