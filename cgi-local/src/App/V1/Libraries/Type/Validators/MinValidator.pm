package V1::MinValidator;
{
    use Validator;

    sub new {
        my ($self, $message, $length) = @_;

        return bless {"_message" => $message, "_length" => $length};
    }

    sub validate {
        my ($self, $value) = @_;

        return V1::Validator->new->validate(((length $value) > $self->{_length}), $self->{_message});
    }
    
}
1;