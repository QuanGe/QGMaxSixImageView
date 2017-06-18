Pod::Spec.new do |s|
  s.name     = 'QGMaxSixImageView'
  s.version  = '0.1.0'
  s.platform = :ios, '7.0'
  s.license  = 'MIT'
  s.summary  = 'the view has max six image view '
  s.homepage = 'https://github.com/QuanGe/QGMaxSixImageView'
  s.author   = { 'QuanGe' => 'zhang_ru_quan@163.com' }
  s.source   = { :git => 'https://github.com/QuanGe/QGMaxSixImageView.git', :tag => s.version.to_s }

  s.description = 'the view has max six image view' 

  s.frameworks   = 'QuartzCore'
  s.source_files = 'QGMaxSixImageView/*.{h,m}'
  s.resources = ['QGMaxSixImageView/*.{xib}']
  s.preserve_paths  = 'Demo'
  s.requires_arc = true
end
