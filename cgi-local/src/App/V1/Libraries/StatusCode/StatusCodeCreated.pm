
package V1::StatusCodeCreated;
{
    sub response {
        $message = $_[0];

        return {
            "statusCode" => "201",
            "code" => "201 Created",
            "message" => $message
        };
    }
}
1;