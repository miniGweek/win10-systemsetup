$process = Start-Process -FilePath .\executables\vs_Enterprise.exe `
    -ArgumentList "--installPath", "C:\VS", `
    "--addProductLang", "en-US", `
    "--add", "Microsoft.VisualStudio.Workload.CoreEditor", `
    "--add", "Microsoft.VisualStudio.Workload.Azure", `
    "--add", "Microsoft.VisualStudio.Workload.Data", `
    "--add", "Microsoft.VisualStudio.Workload.ManagedDesktop", `
    "--add", "Microsoft.VisualStudio.Workload.NetCoreTools", `
    "--add", "Microsoft.VisualStudio.Workload.NetWeb", `
    "--add", "Component.GitHub.VisualStudio", `
    "--includeRecommended", `
    "--passive", "--wait" -Wait -PassThru

Write-Output $process.ExitCode