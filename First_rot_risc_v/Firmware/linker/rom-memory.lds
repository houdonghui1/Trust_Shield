MEMORY
{
  bootrom_mem (rx) : ORIGIN = 0x10000, LENGTH = 0x1FFFF
  memory_mem (rwx) : ORIGIN = 0x8020000, LENGTH = 0x1FFFF
}
