
package V1::StatusCodeOK;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "200",
            "code" => "200 OK",
            "message" => $message
        };
    }
}
1;