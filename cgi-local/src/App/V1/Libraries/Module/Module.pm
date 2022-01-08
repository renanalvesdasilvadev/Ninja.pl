package V1::Module;
{
    use StatusCodeNotFound;
    use JSON;
    use Try::Tiny;

    sub new {
        my ($class) = @_;
        
        my $self = {
            "getRoutes" => {},
            "postRoutes" => {},
            "putRoutes" => {},
            "deleteRoutes" => {},            
            "providers" => {}
        };

        bless $self, $class;

        return $self;
    }

    sub getModule {
        my ($self) = @_;

        return {
            "getRoutes" => $self->{"getRoutes"},
            "postRoutes" => $self->{"postRoutes"},
            "putRoutes" => $self->{"putRoutes"},
            "deleteRoutes" => $self->{"deleteRoutes"},
            "providers" => $self->{"providers"}
        };
    }

    sub registerModule {
        my ($self, $module) = @_;

        $moduleAttributes = $module->getModule();

        foreach my $key (keys %{$moduleAttributes->{"getRoutes"}}) {
            $self->{"getRoutes"}->{$key} = $moduleAttributes->{"getRoutes"}->{$key};
        }
        foreach my $key (keys %{$moduleAttributes->{"postRoutes"}}) {
            $self->{"postRoutes"}->{$key} = $moduleAttributes->{"postRoutes"}->{$key};
        }
        foreach my $key (keys %{$moduleAttributes->{"putRoutes"}}) {
            $self->{"putRoutes"}->{$key} = $moduleAttributes->{"putRoutes"}->{$key};
        }
        foreach my $key (keys %{$moduleAttributes->{"deleteRoutes"}}) {
            $self->{"deleteRoutes"}->{$key} = $moduleAttributes->{"deleteRoutes"}->{$key};
        }
        foreach my $key (keys %{$moduleAttributes->{"providers"}}) {
            $self->{"providers"}->{$key} = $moduleAttributes->{"providers"}->{$key};
        }
    }

    sub registerRoute {
        my ($self, $verb, $uri, $packageUse, $package, $method, $middlewares) = @_;
        $self->{$verb."Routes"}->{$uri} = {"package" => $package, "packageUse" => $packageUse, "method" => $method, "middlewares" => $middlewares};
    }

    sub registerProvider {
        my ($self, $providerName, $packageUse, $package, $providers, $factory) = @_;
        $self->{"providers"}->{$providerName} = {"packageUse" => $packageUse, "package" => $package, "providers" => $providers, "factory" => $factory};
    }

    sub getProvidersByList {
        my ($self, $providersList) = @_;

        my @dependencies = ();

        foreach my $providerName (@{$providersList}) {
            my $provider = $self->{"providers"}->{$providerName};

            if(!$provider) {
                die "Provider $providerName is not exists!";                
            }
            my @dependenciesInjectionProvider = ();
            my @dependenciesInjectionProvidersFactory = ();

            if($provider->{"providers"} && scalar @{$provider->{"providers"}} > 0) {
                @dependenciesInjectionProviders = $self->getProvidersByList($provider->{"providers"});
            }

            if($provider->{"factory"}) {
                @dependenciesInjectionProvidersFactory = $provider->{"factory"}();
            }

            eval "use $provider->{packageUse};";

            my $instance = $provider->{"package"}->new(@dependenciesInjectionProviders, @dependenciesInjectionProvidersFactory);
            
            push @dependencies, $instance;
        }

        return @dependencies;
    }

    sub provideDependenciesInjections {
        my ($self, $package) = @_;

        eval "use $package;";
        
        my @dependencies = ();

        if(!$package->DEPENDENCIES_PROVIDERS){
            die "Package does not have dependencies providers'!";
        }

        @dependencies = $self->getProvidersByList($package->DEPENDENCIES_PROVIDERS);
        
        return @dependencies;

    }

    sub existsRoute {
        my ($self, $verb, $uri) = @_;      
        
        if(!$self->{$verb."Routes"}->{$uri}) {
            return 0;
        }

        return 1;
    }

    sub executeRouteMethod {
        my ($self, $verb, $uri, $payload) = @_;       

        if(!$self->existsRoute($verb, $uri)){
            return V1::StatusCodeNotFound::response encode_json ["Route not found!"];
        }

        my $route = $self->{$verb."Routes"}->{$uri};

        if($route->{"middlewares"}) {

            foreach my $middleware (@{$route->{"middlewares"}}) {
            
                my $middlewareData = $middleware->execute($payload);
                $payload->{"middlewareData"}->{$middlewareData->{"property"}} = $middlewareData->{"value"};
            
            }

        }

        my $package = $route->{"package"};
        my $packageUse = $route->{"packageUse"};
        my $method  = $route->{"method"};  

        eval "use $packageUse;";
        
        my @dependencies = ();
        
        if (defined($package->USE_DEPENDENCY_INJECTION) && $package->USE_DEPENDENCY_INJECTION) {
            @dependencies = $self->provideDependenciesInjections($package);
        }

        my $instance = $package->new(@dependencies);
        
        return $instance->$method($payload);

    }
}
1;