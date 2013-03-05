guard :ocunit,
      :test_paths       => ['WaniKaniTests'],
      :build_variables  => "ONLY_ACTIVE_ARCH=NO GCC_PREPROCESSOR_DEFINITIONS='$GCC_PREPROCESSOR_DEFINITIONS OCUNIT=1'",
      :workspace        => 'WaniKani.xcworkspace',
      :scheme           => 'WaniKani',
      :test_bundle      => 'WaniKaniTests' do

  watch(%r{^WaniKaniTests/Models/.+Tests\.m})
  watch(%r{^WaniKaniTests/Common/.+Tests\.m})
  watch(%r{^WaniKaniTests/ViewControllers/.+Tests\.m})
  watch(%r{^WaniKaniTests/Views/.+Tests\.m})

  watch(%r{^WaniKani/Models/(.+)\.[m,h]$})           { |m| "WaniKaniTests/Models/#{m[1]}Tests.m" }
  watch(%r{^WaniKani/Common/(.+)\.[m,h]$})           { |m| "WaniKaniTests/Common/#{m[1]}Tests.m" }
  watch(%r{^WaniKani/ViewControllers/(.+)\.[m,h]$})  { |m| "WaniKaniTests/ViewControllers/#{m[1]}Tests.m" }
  watch(%r{^WaniKani/Views/(.+)\.[m,h]$})            { |m| "WaniKaniTests/Views/#{m[1]}Tests.m" }
end
