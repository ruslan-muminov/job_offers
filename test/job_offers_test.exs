defmodule JobOffersTest do
  alias JobOffers.{Api, EtsHelper}

  use ExUnit.Case
  
  import ExUnit.CaptureIO

  describe "continents grouping" do
    test "parse professions" do
      professions = JobOffers.parse_professions

      assert Map.get(professions, "1") == {"Audit / Finance", "Business"}
      assert Map.get(professions, "42") == {"Production/Fabrication", "Retail"}
    end

    test "job offers count per category per continent: output" do
      fun = fn -> JobOffers.category_continent_job_offers_count end

      assert capture_io(fun) == category_continent_job_offers_output()
    end

    test "job offers count per category per continent: result" do
      assert JobOffers.category_continent_job_offers_count == category_continent_job_offers_result()
    end
  end

  describe "api" do
    test "job offers around location" do
      assert :ok == EtsHelper.init_tables()

      assert Api.job_offers_around_location(13.7, 100.5, 10) == offers_around_location_bangkok()
      assert Api.job_offers_around_location(13.7, 100.5, 5) == {:ok, []}
      assert {:error, _} = Api.job_offers_around_location(13.7, 100.5, "5")
    end
  end

  ###############################################################
  ## Some useful stuff
  ###############################################################

  defp offers_around_location_bangkok do
    {:ok, [
      {"Relation client / Support", "Business", "FULL_TIME", "IT Supervisor (m/f)", 13.7428119, 100.549696, 7.175},
      {"Relation client / Support", "Business", "FULL_TIME", "IT Supervisor", 13.7563309, 100.5017651, 6.267},
      {"Relation client / Support", "Business", "FULL_TIME", "Group IT Supervisor", 13.7563309, 100.5017651, 6.267},
      {"BizDev / Vente", "Business", "FULL_TIME", "FR - Agent Local - Thaïlande", 13.7563309, 100.5017651, 6.267},
      {"BizDev / Vente", "Business", "FULL_TIME", "Assistant Manager – Digital Media Buyer", 13.7563309, 100.5017651, 6.267}
    ]}
  end

  defp category_continent_job_offers_output do
"""
+---------------+-------+-------+----------+---------+------+-------------------+--------+------+
|               | Total | Admin | Business | Conseil | Créa | Marketing / Comm' | Retail | Tech |
| Total         | 4965  | 407   | 1436     | 175     | 212  | 776               | 528    | 1431 |
| AFRICA        | 9     | 1     | 3        | 0       | 0    | 1                 | 1      | 3    |
| ASIA          | 51    | 1     | 30       | 0       | 0    | 3                 | 6      | 11   |
| AUSTRALIA     | 1     | 0     | 0        | 0       | 0    | 0                 | 1      | 0    |
| EUROPE        | 4735  | 396   | 1372     | 175     | 205  | 759               | 426    | 1402 |
| NORTH_AMERICA | 156   | 9     | 27       | 0       | 7    | 12                | 87     | 14   |
| OTHER_WORLD   | 8     | 0     | 0        | 0       | 0    | 1                 | 7      | 0    |
| SOUTH_AMERICA | 5     | 0     | 4        | 0       | 0    | 0                 | 0      | 1    |
+---------------+-------+-------+----------+---------+------+-------------------+--------+------+

Total incorrect rows: 104
"""
  end

  defp category_continent_job_offers_result do
    {:ok,
     {%{
        {"AFRICA", "Admin"} => 1,
        {"AFRICA", "Business"} => 3,
        {"AFRICA", "Marketing / Comm'"} => 1,
        {"AFRICA", "Retail"} => 1,
        {"AFRICA", "Tech"} => 3,
        {"ASIA", "Admin"} => 1,
        {"ASIA", "Business"} => 30,
        {"ASIA", "Marketing / Comm'"} => 3,
        {"ASIA", "Retail"} => 6,
        {"ASIA", "Tech"} => 11,
        {"AUSTRALIA", "Retail"} => 1,
        {"EUROPE", "Admin"} => 396,
        {"EUROPE", "Business"} => 1372,
        {"EUROPE", "Conseil"} => 175,
        {"EUROPE", "Créa"} => 205,
        {"EUROPE", "Marketing / Comm'"} => 759,
        {"EUROPE", "Retail"} => 426,
        {"EUROPE", "Tech"} => 1402,
        {"NORTH_AMERICA", "Admin"} => 9,
        {"NORTH_AMERICA", "Business"} => 27,
        {"NORTH_AMERICA", "Créa"} => 7,
        {"NORTH_AMERICA", "Marketing / Comm'"} => 12,
        {"NORTH_AMERICA", "Retail"} => 87,
        {"NORTH_AMERICA", "Tech"} => 14,
        {"OTHER_WORLD", "Marketing / Comm'"} => 1,
        {"OTHER_WORLD", "Retail"} => 7,
        {"SOUTH_AMERICA", "Business"} => 4,
        {"SOUTH_AMERICA", "Tech"} => 1
      },
      %{
        "AFRICA" => 9,
        "ASIA" => 51,
        "AUSTRALIA" => 1,
        "EUROPE" => 4735,
        "NORTH_AMERICA" => 156,
        "OTHER_WORLD" => 8,
        "SOUTH_AMERICA" => 5
      },
      %{
        "Admin" => 407,
        "Business" => 1436,
        "Conseil" => 175,
        "Créa" => 212,
        "Marketing / Comm'" => 776,
        "Retail" => 528,
        "Tech" => 1431
      },
      %{"error" => 104, "total" => 4965}}}
  end
end
