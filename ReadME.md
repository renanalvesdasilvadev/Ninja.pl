# Framework Ninja.pl! Web Api

<br>

## Motiva��o
> A motiva��o � facilitar o desenvolvimento de aplica��es voltadas para a web, permitindo que os desenvolvedores utilizem inje��es de deped�ncia promovendo desacoplamento de suas aplica��es, e tamb�m organizem melhor seu c�digo com M�dulos assim facilitando o desenvolvimento de novas arquiteturas. O framework tamb�m conta com uma biblioteca de valida��o de tipos, onde � poss�vel definir o padr�o do payload com multiplos n�vel e validando o payload de uma s� vez. Tamb�m � poss�vel utilizar o ORM Sequelado para utiliza��o de models e comunica��es com o banco de dados.

## Documenta��o

### Fluxograma de Requisi��es
![plot](./ReadMe/Flowchart.request.png)

### Instala��o na DEVBOX
> A devbox vem inicialmente desatualizada e devemos inserir os arquivos do reposit�rio git faltando na mesma e checar as permiss�es dos arquivos faltante, garantir que os arquivos estejam pelo menos com permiss�o 755 ou 744.
    
### Arquivos faltantes da API na DEVBOX pasta GLOBAL
> Pasta inteira APP/public_html/cgi-local/api

> Arquivo htaccess APP/public_html/.htaccess

## Dir�torio Inicial

### Startup.cgi
> Este serve como ponto de entrada para todas as requisi��es na WebAPI, nele � poss�vel interceptar as requisi��es atrav�s de Middlewares, e aplicar regras que possam servir para uma ou mais rotas.Tamb�m � realizado o Autoload das bibliotecas padr�es do projeto e da Aplica��o a ser executada.

## src/App

### Modules
> Um m�dulo � respons�vel por gerenciar sua aplica��o, com ele � poss�vel:
> - Registrar providers para utilizar em inje��o de deped�ncias
> - Registrar um controller que servir� como porta de entrada para sua aplica��o
> - Resolver inje��es de deped?ncia: Caso um m�dulo esteja configurado, para receber uma depend�ncia, � o Module que fica respons�vel por resolver.
> - Registrar outros Modules: Esse recurso permite organizar melhor sua aplica��o, onde em uma arquitetura em camadas, voc� pode registrar seus providers e controllers em camadas mais internas e depois agrupar todos os m�dulos em apenas um.
> - Executar uma rota: Passando os par�metros necess�rios, o m�dulo busca a rota informada e executa seu devido controller.
<Br>
> Exemplo:
```
package V1::Department::TodoModule;
{
    use V1::Libraries::Module::Module;    
    our @ISA = qw(V1::Module);
    use V1::Modules::Department::Application::Modules::Providers::CoreProviders;
    use V1::Modules::Department::Application::Modules::Providers::InfraProviders;

    sub new {
        my ($class) = @_;

        my $self = {}; 
        my $self = $class->SUPER::new();                   

        bless $self, $class; 

        $self->registerRoute('post', '/api2/v1/Department/Todo1/Sell', 'V1::Modules::Department::Application::Controllers::Http::Todo1Controller', 'V1::Todo1Controller', 'sellTodo1', [$middleware]);
        $self->registerRoute('post', '/api2/v1/Department/Todo1', 'V1::Modules::Department::Application::Controllers::Http::Todo1Controller', 'V1::Todo1Controller', 'createTodo1', [$middleware]);
        $self->registerProvider(V1::Department::CoreProviders::TODO1_SERVICE_PROVIDER, 'V1::Modules::Department::Core::Services::Todo1::Todo1Service', 'V1::Todo1Service', 
            #we can return all provider dependencies
            [
                V1::Department::InfraProviders::TODO1_REPOSITORY_PROVIDER, V1::Department::InfraProviders::FOO_COMMUNICATION_ADAPTER_PROVIDER
            ], 
            sub {
                #we can return all provider dependencies
                return ();
            }
        );
        $self->registerModule(V1::Foo::FooModule->new());     

        return $self;
    }      

}
1;
```


### Status Code
> A biblioteca status code serve como uma forma de padronizar toda a comunica��o entre seu sistema, possibilitando que retorne desde mensagens formatadas com sucesso, erro ou alertas. Para Rest Api's, � poss�vel utilizar a biblioteca Response.pm para retornar uma mensagem formatada ao cliente, devolvendo com o c�digo de status correto. Por padr�o o Startup.cgi j� utilizar o Response.pm para retornar a mensagem de todas as requisi��es.

### Controllers
> O controller serve como porta de entrada para a camada externa da aplica��o, todas as requisi��es HTTP passam obrigat�riamente por ele.
<br><br>
> <b>Inje��o de deped�ncia:</b>
<br>
> Para utilizar inje��o de depend�ncia no controller, basta declarar duas constantes no package.
<br><br>
> use constant USE_DEPENDENCY_INJECTION => 1;
<br>
> use constant DEPENDENCIES_PROVIDERS => [
        'FooService', 'TodoService'
    ];
<br><br>
> Isso faz com que o m�dulo identifique que ele precisa inst�nciar estes providers e passa-los obrigatoriamente no m�todo construtor do Controller.
<br><Br>
> Exemplo:
<br><Br>
```
package V1::Todo1Controller;
{    
    use V1::Modules::Department::Application::Modules::Providers::CoreProviders;
    use constant USE_DEPENDENCY_INJECTION => 1;
    use constant DEPENDENCIES_PROVIDERS => [
        V1::Department::CoreProviders::TODO1_SERVICE_PROVIDER, V1::Department::CoreProviders::SELL_TODO1_SERVICE_PROVIDER
    ];
    sub new {
        my ($class, $todo1Service, $sellTodo1Service) = @_;
        
        return bless {
            "todo1Service" => $todo1Service,
            "sellTodo1Service" => $sellTodo1Service
        }, $class;
    }

    sub sellTodo1 {
        my ($self, $payload) = @_;

        return $self->{"sellTodo1Service"}->execute($payload);
    }

    sub createTodo1 {
        my ($self, $payload) = @_;
    
        return $self->{"todo1Service"}->create($payload);
    }

    sub getTodo1ById {
        my ($self, $payload) = @_;        
        
        return $self->{"todo1Service"}->getById($payload);
    }
}
1;
```
### Routes
> Para registrar uma rota em seu m�dulo, basta utilizar esse comando no m�todo construtor do m�dulo:
<br><br>
```
package V1::Department::ApplicationModule;
{
    use V1::Libraries::Middlewares::AuthenticateMiddleware;
    use V1::Libraries::Module::Module;    
    our @ISA = qw(V1::Module);

    sub new {
        my ($class) = @_;

        my $self = {}; 
        my $self = $class->SUPER::new();                   

        bless $self, $class;

        $self->registerTodo1Controller();          

        return $self;
    }      

    sub registerTodo1Controller {
        my ($self) = @_;

        my $middleware = V1::AuthenticateMiddleware->new();

        $self->registerRoute('post', '/api2/v1/Department/Todo1/Sell', 'V1::Modules::Department::Application::Controllers::Http::Todo1Controller', 'V1::Todo1Controller', 'sellTodo1', [$middleware]);
        $self->registerRoute('post', '/api2/v1/Department/Todo1', 'V1::Modules::Department::Application::Controllers::Http::Todo1Controller', 'V1::Todo1Controller', 'createTodo1', [$middleware]);
        $self->registerRoute('get', '/api2/v1/Department/Todo1', 'V1::Modules::Department::Application::Controllers::Http::Todo1Controller', 'V1::Todo1Controller', 'getTodo1ById', []);
        $self->registerRoute('get', '/api2/v1/Department/Todo2', 'V1::Modules::Department::Application::Controllers::Http::Todo2Controller', 'V1::Todo2Controller', 'getTodo2ById', []);
    }
}
1;
```
> - 1� Par�metro: Verbo da requisi��o (padr�o caixa baixa)
> - 2� Par�metro: URI (Aqui voc� define a rota de acesso que dever� ser utilizada pelo cliente. OBS: Deve existir apenas uma rota com o mesmo nome por verbo, caso contr�rio voc� ter� problemas!)
> - 3� Par�metro: Use Package (Aqui voc� deve informar como o m�dulo deve utilizar o use package do controller)
> - 4� Par�metro: Package Name (Aqui voc� informa o nome do package do Controller)
> - 5� Par�metro: Function Name (Aqui voc� informa qual � o nome da sub que o m�dulo dever� executar)
> - 6� Par�metro: Middlewares (Aqui voc� pode instanciar e utilizar uma lista de middlewares para serem executados antes de ser acessado o m�todo de destino no controller).

### Middlewares
> O middleware � uma classe executada antes do m�dulo executar a rota de destino. A requisi��o � interceptada pelo middleware, no qual possibilita validar a sess�o do usu�rio, se o mesmo possui permiss�o para acessar aquela rota, entre outras valida��es. Tamb�m � poss�vel incluir informa��es do middleware no payload, por exemplo dados de sess�o do usu�rio.

### Type
> Com o m�dulo Type � poss�vel definir validadores customizaveis para um payload, como um validador de classes. Tamb�m � poss�vel setar um type dentro do outro, possibilitando que fa�a uma valida��o recursiva de seu payload.
<Br><br>
> Exemplo:
<Br>
```
package V1::CreateTodo1RequestDTO;
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
        $phone->setAttribute("phone", [>
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
```

### Inje��o de Depend�ncia
> <b>Controllers:</b>
> <br><br>
> Para utilizar inje��o de depend�ncia no controller, basta declarar duas constantes no package.
<br><br>
> use constant USE_DEPENDENCY_INJECTION => 1;
<br>
> use constant DEPENDENCIES_PROVIDERS => [
        'FooService', 'TodoService'
    ];
<br><br>
> Isso faz com que o m�dulo identifique que ele precisa inst�nciar estes providers e passa-los obrigatoriamente no m�todo construtor do Controller.
<br><Br>
> Exemplo:
<br><Br>
```
package V1::Todo1Controller;
{    
    use V1::Modules::Department::Application::Modules::Providers::CoreProviders;
    use constant USE_DEPENDENCY_INJECTION => 1;
    use constant DEPENDENCIES_PROVIDERS => [
        V1::Department::CoreProviders::TODO1_SERVICE_PROVIDER, V1::Department::CoreProviders::SELL_TODO1_SERVICE_PROVIDER
    ];
    sub new {
        my ($class, $todo1Service, $sellTodo1Service) = @_;
        
        return bless {
            "todo1Service" => $todo1Service,
            "sellTodo1Service" => $sellTodo1Service
        }, $class;
    }

    sub sellTodo1 {
        my ($self, $payload) = @_;

        return $self->{"sellTodo1Service"}->execute($payload);
    }

    sub createTodo1 {
        my ($self, $payload) = @_;
    
        return $self->{"todo1Service"}->create($payload);
    }

    sub getTodo1ById {
        my ($self, $payload) = @_;        
        
        return $self->{"todo1Service"}->getById($payload);
    }
}
1;
```
> <b>Providers:</b>
> <br><br>
> Existem duas maneiras de utilizar inje��o de depend�ncia em um provider.
> - 1� Providers List:
> <br>
```
$self->registerProvider(V1::Department::CoreProviders::TODO1_SERVICE_PROVIDER,            'V1::Modules::Department::Core::Services::Todo1::Todo1Service', 'V1::Todo1Service',     
    [
        # Aqui voc� informa a lista de providers
        'Provider1', 'Provider2'
    ], 
    sub {
        #we can return all provider dependencies
        return ();
    }
);
```
> - 2� Factory
```
$self->registerProvider(V1::Department::CoreProviders::TODO1_SERVICE_PROVIDER,            'V1::Modules::Department::Core::Services::Todo1::Todo1Service', 'V1::Todo1Service',     
    [], 
    sub {
        # Aqui voc� pode inst�nciar manualmente seus m�dulos e retornar em forma de array.
        my $provider1 = Provider1->new();
        my $provider2 = Provider2->new();
        return ($provider1, $provider2);
    }
);
```