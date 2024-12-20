#include "ydb_admin.h"

#include "ydb_dynamic_config.h"
#include "ydb_storage_config.h"

namespace NYdb {
namespace NConsoleClient {

TCommandAdmin::TCommandAdmin()
    : TClientCommandTree("admin", {}, "Administrative cluster operations")
{
    AddCommand(std::make_unique<NDynamicConfig::TCommandConfig>());
    AddCommand(std::make_unique<NDynamicConfig::TCommandVolatileConfig>());
    AddCommand(std::make_unique<NStorageConfig::TCommandStorageConfig>());
}

}
}
