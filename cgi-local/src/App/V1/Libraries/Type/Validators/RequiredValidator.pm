package V1::RequiredValidator;
{
    use Validator;    

    sub new {
        my ($self, $message) = @_;      

        return bless {"_message" => $message};
    }

    sub getMessage {
        my $self = shift;

        return $self->{message};
    }

    sub validate {
        my ($self, $value) = @_;
        return V1::Validator->new->validate($value ne undef || $value > 0, $self->{_message});
    }
    
}
1;