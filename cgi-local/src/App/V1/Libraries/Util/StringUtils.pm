package V1::StringUtils;
{
    sub  trim {         
        my $s = shift; 
        $s =~ s/^\s+|\s+$//g; 
        return $s 
    }
}
1;