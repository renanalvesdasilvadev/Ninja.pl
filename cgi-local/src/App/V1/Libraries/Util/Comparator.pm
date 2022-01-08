package V1::Comparator;
{
    use Try::Tiny;
    use JSON;
    use Scalar::Util qw(looks_like_number);

    sub new{
        return bless {};
    }

    sub isJson {
        
        $json = $_[0];      
        
        try {            
            decode_json $json;
            return 1;
        }   
        catch {
            return 0;
        };

    }

    sub hasOnlyNumberInArray {
        my ($array) = @_;
        my $hasNumber = 1;
        
        try {
            foreach my $element ( @{$array} ) {
                if(!looks_like_number($element)) {
                    $hasNumber = 0;
                }
            }

            return $hasNumber;
        } catch {
            return 0;
        }
    }
}
1;