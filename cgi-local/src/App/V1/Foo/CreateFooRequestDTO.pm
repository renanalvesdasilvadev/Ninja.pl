package V1::Foo::CreateFooRequestDTO;
{
    use PayloadAttributes;
    use RequiredValidator;
    use IntegerValidator;
    our @ISA = qw(V1::PayloadAttributes);

    sub new {
        my ( $class ) = @_;        
        my $self = $class->SUPER::new();               
        bless $self, $class;

        my $phone = V1::PayloadAttributes->new();
        $phone->setAttribute("phone", [
                V1::RequiredValidator->new("Field 'address' is required!")
        ]);

        my $address = V1::PayloadAttributes->new();
        $address->setAttribute("address", [
                V1::RequiredValidator->new("Field 'address' is required!")
        ]);
        $address->setAttribute("city", [
                V1::RequiredValidator->new("Field 'city' is required!")
        ]);
        $address->setPayloadAttribute("phone", $phone, [
                V1::RequiredValidator->new("Field 'phone' is required!")
        ]);

        $self->setAttribute("name", [
                V1::RequiredValidator->new("Field 'name' is required!")
        ]);
        $self->setAttribute("email", [
                V1::RequiredValidator->new("Field 'email' is required!")
        ]);
        $self->setAttribute("years", [
                V1::RequiredValidator->new("Field 'years' is required!"),
                V1::IntegerValidator->new("Field 'years' is required!")
        ]);
        $self->setPayloadAttribute("address", $address, [
                V1::RequiredValidator->new("Field 'address' is required!")
        ]);
        return $self;
    }
}
1;