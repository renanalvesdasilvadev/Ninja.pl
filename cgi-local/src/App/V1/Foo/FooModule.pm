package V1::Foo::FooModule;
{
    use V1::Libraries::Middlewares::AuthenticateMiddleware;
    use V1::Libraries::Module::Module;    
    use V1::Foo::FooProviders;
    our @ISA = qw(V1::Module);

    sub new {
        my ($class) = @_;

        my $self = {}; 
        my $self = $class->SUPER::new();                   

        bless $self, $class;

        $self->registerFooController();  
        $self->registerProviders();                 

        return $self;
    }      

    sub registerFooController {
        my ($self) = @_;

        my $middleware = V1::AuthenticateMiddleware->new();
        
        $self->registerRoute('post', '/api3/v1/Foo', 'V1::Foo::FooController', 'V1::Foo::FooController', 'createFoo', [$middleware]);        
    }

    sub registerProviders {
        my ($self) = @_;

        $self->registerProvider(V1::Foo::FooProviders::FOO_REPOSITORY_PROVIDER, 'V1::Foo::FooRepository', 'V1::Foo::FooRepository', 
            #we can return all provider dependencies
            [], 
            sub {
                #we can return all provider dependencies
                return ();
            }
        );
        $self->registerProvider(V1::Foo::FooProviders::CREATE_FOO_SERVICE_PROVIDER, 'V1::Foo::CreateFooService', 'V1::Foo::CreateFooService', 
            #we can return all provider dependencies
            [
                V1::Foo::FooProviders::FOO_REPOSITORY_PROVIDER
            ], 
            sub {
                #we can return all provider dependencies
                return ();
            }
        );
    }
}
1;