// Example of configuring Application
Public void ConfigureServices(IServiceCollection services)
{
    services.AddApplicationInsightsTelemetry(Configuration["AppicationInsights: InstrumentationKey"]);
}