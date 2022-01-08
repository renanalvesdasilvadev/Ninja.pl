package V1::SQSMessageBroker;
{
    
    use Try::Tiny;
    use Amazon::SQS::Simple;

    sub new {

        my ($class, $key, $secret, $queue_endpoint, $confirm_messages, $limit_messages) = @_;            

        my $sqs = Amazon::SQS::Simple->new($key, $secret);
        my $queue = $sqs->GetQueue($queue_endpoint);
        
        return bless {"queue" => $queue, "confirm_messages" => $confirm_messages, "limit_messages" => $limit_messages};
    }

    sub handler {

        my ($self, $routine) = @_;
        
        my $confirm_messages = $self->{"confirm_messages"};

        my @messages = $self->_get_messages();

        if(!defined(@messages) || scalar @messages <= 0){
            return;
        }

        for $m (@messages){

            my $message = $m->MessageBody();

            $routine->($message, $m);

            if($confirm_messages){

                $self->confirm_message($m);

            }

        }

    }

    sub send_message {
        my ($self, $message) = @_;

        my $queue = $self->{"queue"};  

        $queue->SendMessage($message);

    }

    sub confirm_message {
        my ($self, $message) = @_;

        my $queue = $self->{"queue"};   

        $queue->DeleteMessage( $message );
        
    }   

    sub _get_messages { 

        my ($self) = @_;

        my $queue = $self->{"queue"};   
        
        my $limit_messages = $self->{"limit_messages"}; 

        my @messages = ();

        if(!defined($limit_messages)){
            $limit_messages = 1000;
        }

        @messages = $queue->ReceiveMessage(MaxNumberOfMessages=>$limit_messages);
        
        return @messages;

    }

}
1;
