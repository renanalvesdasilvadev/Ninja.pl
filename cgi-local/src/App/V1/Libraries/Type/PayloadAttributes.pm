package V1::PayloadAttributes;
{    
    use JSON::PP;
    use JSON;
    use StringUtils;
    use Data::Dumper;

    sub new {
        return bless {"_attributes" => undef, "_validates" => undef, "_values" => undef, "_payloads" => undef, "_attributeNameConcat" => undef};
    }

    sub setAttribute {
        my ($self, $attribute, $validate) = @_;

        $self->{_attributes}{$attribute} = 1;
        $self->{_values}{$attribute} = undef;
        $self->{_s}{$attribute} = undef;
        $self->{_validates}{$attribute} = $validate;
    }

    sub setAttributeConcatValidators {
        my ($self, $attributeName) = @_;

        $self->{"_attributeNameConcat"} = $attributeName;
    }

    sub setPayloadAttribute {
        my ($self, $attribute, $payload, $validate) = @_;

        $payload->setAttributeConcatValidators($attribute);
        $self->{_attributes}{$attribute} = 2;
        $self->{_values}{$attribute} = undef;
        $self->{_payloads}{$attribute} = $payload;
        $self->{_validates}{$attribute} = $validate;
    }

    sub setValues {      
        my ($self, $values) = @_;           
        
        foreach my $key (keys $values){            
            if($self->{_attributes}{$key} == 1 || $self->{_attributes}{$key} == 2){
                $self->set($key, $values->{$key});                                                 
            }
            if($self->{_attributes}{$key} == 2){
                $self->{_payloads}{$key}->setValues($values->{$key});                                                 
            }
        }             
    }

    sub set {
        my ($self, $attribute, $value) = @_;        
        $self->{_values}{$attribute} = $value;
    }

    sub get {
        my ($self, $attribute) = @_;
        return $self->{_values}{$attribute};
    }

    sub getValues {        
        my ($self) = @_;
        return $self->{_values};
    }

    sub validate {
        $self = $_[0];

        my @messageValidators = ();

        foreach my $key (keys $self->{_values}){
            
            if($self->{_attributes}{$key} == 1 || $self->{_attributes}{$key} == 2) {
                my $messageValidator = $self->validateValue($key);
                if(V1::StringUtils::trim($messageValidator) ne ""){                                                    
                    push @messageValidators, $messageValidator;
                }                             
            }   
            if($self->{_attributes}{$key} == 2) {
                my @payloadValidator = $self->{_payloads}{$key}->validate();
                if(scalar @payloadValidator > 0) {     
                    @newPayloadValidator = ();
                    foreach my $message (@payloadValidator) {                        
                        $message = "'".$key . "' " . $message;  
                        push @newPayloadValidator, $message;
                    }
                    push @messageValidators, @newPayloadValidator;                     
                }                                 
            }
        }    
        
        if(scalar @messageValidators > 0){        
            return @messageValidators;                        
        }        

        return ();

    }

    sub validateValue {
        my ($self, $attribute) = @_;        

        if($self->{_validates}{$attribute} eq undef){
            return "";
        }      

        my $messageValidators = "";
        if($self->{_validates}{$attribute} != undef){
                
            for(@{$self->{_validates}{$attribute}}) {
                
                if($_ != undef){
                    
                    my $messageValidator = $_->validate($self->{_values}{$attribute});
                    
                    if(V1::StringUtils::trim($messageValidator) ne ""){
                                        
                        $messageValidators = $messageValidators . $messageValidator . ", ";   
                     
                    }   
                }

            }
            $messageValidators = substr($messageValidators, 0, (length $messageValidators) - 2 );

        }                
                
        return $messageValidators;
    }
}
1;