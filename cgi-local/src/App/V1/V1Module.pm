package V1::V1Module;
{
    use V1::Foo::FooModule;
    use V1::Libraries::Module::Module;    
    our @ISA = qw(V1::Module);

    sub new {
        my ($class) = @_;

        my $self = {}; 
        my $self = $class->SUPER::new();                   

        bless $self, $class;

        $self->registerModule(V1::Foo::FooModule->new());       

        return $self;
    }      
}
1;