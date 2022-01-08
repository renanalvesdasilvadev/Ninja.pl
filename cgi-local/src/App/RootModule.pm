package RootModule;
{
    use V1::V1Module;
 
    use StatusCodeNotFound;
    our @ISA = qw(V1::Module);

    sub new {
        my ($class) = @_;

        my $self = {}; 
        my $self = $class->SUPER::new();   

        bless $self, $class;

        $self->registerModule(V1::V1Module->new());  


        return $self;                
    }
}
1;