class ApplicationApi < Grape::API
  prefix 'api'
  mount V1::V1GrapeBase
end
