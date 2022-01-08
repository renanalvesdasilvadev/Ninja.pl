package V1::Exception;
{    
    
    sub throw {
        my ($message) = @_;        

        die $message;
    }
    
}
1;