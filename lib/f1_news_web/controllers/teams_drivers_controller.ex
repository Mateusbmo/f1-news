defmodule F1NewsWeb.TeamsDriversController do
  use F1NewsWeb, :controller

  def index(conn, _params) do
    teams = [
      %{
        id: 1,
        name: "Ferrari",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/ferrari-logo.png",
        history: "Fundada em 1929, a Scuderia Ferrari é a equipe mais icônica da F1, com 16 títulos de construtores.",
        drivers: ["Charles Leclerc", "Carlos Sainz"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/ferrari-car.png"
      },
      %{
        id: 2,
        name: "Red Bull Racing",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/red-bull-racing-logo.png",
        history: "Criada em 2005, a Red Bull dominou com 6 títulos de construtores e pilotos como Verstappen.",
        drivers: ["Max Verstappen", "Sergio Pérez"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/red-bull-racing-car.png"
      },
      %{
        id: 3,
        name: "McLaren",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/mclaren-logo.png",
        history: "Fundada em 1963 por Bruce McLaren, tem 8 títulos de construtores e lendas como Senna.",
        drivers: ["Lando Norris", "Oscar Piastri"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/mclaren-car.png"
      },
      %{
        id: 4,
        name: "Mercedes",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/mercedes-logo.png",
        history: "Dominou a era híbrida com 8 títulos consecutivos (2014-2021), liderada por Hamilton.",
        drivers: ["Lewis Hamilton", "George Russell"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/mercedes-car.png"
      },
      %{
        id: 5,
        name: "Aston Martin",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/aston-martin-logo.png",
        history: "Retornou à F1 em 2021, com ambições lideradas por Lawrence Stroll e Alonso.",
        drivers: ["Fernando Alonso", "Lance Stroll"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/aston-martin-car.png"
      },
      %{
        id: 6,
        name: "Alpine",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/alpine-logo.png",
        history: "Sucessora da Renault, venceu em 2021 com Ocon e busca retomar a glória.",
        drivers: ["Esteban Ocon", "Pierre Gasly"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/alpine-car.png"
      },
      %{
        id: 7,
        name: "Williams",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/williams-logo.png",
        history: "Fundada em 1977, tem 9 títulos de construtores, mas enfrenta desafios recentes.",
        drivers: ["Alex Albon", "Franco Colapinto"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/williams-car.png"
      },
      %{
        id: 8,
        name: "RB",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/rb-logo.png",
        history: "Equipe irmã da Red Bull, foca em jovens talentos como Tsunoda.",
        drivers: ["Yuki Tsunoda", "Liam Lawson"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/rb-car.png"
      },
      %{
        id: 9,
        name: "Sauber",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/sauber-logo.png",
        history: "Será Audi em 2026, mas atualmente luta na parte de trás do grid.",
        drivers: ["Valtteri Bottas", "Zhou Guanyu"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/sauber-car.png"
      },
      %{
        id: 10,
        name: "Haas",
        logo: "https://www.formula1.com/content/dam/fom-website/teams/2023/haas-f1-team-logo.png",
        history: "Estreou em 2016, é a menor equipe da F1, mas surpreende com Magnussen.",
        drivers: ["Kevin Magnussen", "Nico Hülkenberg"],
        car_image: "https://www.formula1.com/content/dam/fom-website/teams/2023/haas-f1-team-car.png"
      }
    ]

    drivers = [
      %{
        id: 1,
        name: "Charles Leclerc",
        number: 16,
        team: "Ferrari",
        nationality: "Mônaco",
        bio: "Estrela em ascensão, venceu em casa no GP de Mônaco 2024.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png"
      },
      %{
        id: 2,
        name: "Carlos Sainz",
        number: 55,
        team: "Ferrari",
        nationality: "Espanha",
        bio: "Vencedor do GP da Austrália 2023, conhecido por sua consistência.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png"
      },
      %{
        id: 3,
        name: "Max Verstappen",
        number: 1,
        team: "Red Bull Racing",
        nationality: "Holanda",
        bio: "Tricampeão mundial, conhecido por sua agressividade e consistência.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png"
      },
      %{
        id: 4,
        name: "Sergio Pérez",
        number: 11,
        team: "Red Bull Racing",
        nationality: "México",
        bio: "Especialista em gestão de pneus, venceu em Mônaco e Jeddah.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/S/SERPER01_Sergio_Perez/serper01.png"
      },
      %{
        id: 5,
        name: "Lando Norris",
        number: 4,
        team: "McLaren",
        nationality: "Reino Unido",
        bio: "Jovem talento, conquistou sua primeira vitória em Miami 2024.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png"
      },
      %{
        id: 6,
        name: "Oscar Piastri",
        number: 81,
        team: "McLaren",
        nationality: "Austrália",
        bio: "Estreante promissor, venceu a corrida sprint na Hungria 2024.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png"
      },
      %{
        id: 7,
        name: "Lewis Hamilton",
        number: 44,
        team: "Mercedes",
        nationality: "Reino Unido",
        bio: "Sete vezes campeão mundial, igualou o recorde de Schumacher.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png"
      },
      %{
        id: 8,
        name: "George Russell",
        number: 63,
        team: "Mercedes",
        nationality: "Reino Unido",
        bio: "Vencedor do GP do Brasil 2022, futuro líder da Mercedes.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png"
      },
      %{
        id: 9,
        name: "Fernando Alonso",
        number: 14,
        team: "Aston Martin",
        nationality: "Espanha",
        bio: "Bicampeão mundial, retornou ao pódio com a Aston Martin em 2023.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png"
      },
      %{
        id: 10,
        name: "Lance Stroll",
        number: 18,
        team: "Aston Martin",
        nationality: "Canadá",
        bio: "Filho de Lawrence Stroll, busca consistência na F1.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/L/LANSTR01_Lance_Stroll/lanstr01.png"
      },
      %{
        id: 11,
        name: "Esteban Ocon",
        number: 31,
        team: "Alpine",
        nationality: "França",
        bio: "Vencedor do GP da Hungria 2021, talento da escola francesa.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png"
      },
      %{
        id: 12,
        name: "Pierre Gasly",
        number: 10,
        team: "Alpine",
        nationality: "França",
        bio: "Vencedor do GP da Itália 2020, busca recuperar forma.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png"
      },
      %{
        id: 13,
        name: "Alex Albon",
        number: 23,
        team: "Williams",
        nationality: "Tailândia",
        bio: "Liderou a recuperação da Williams com pontos em 2023.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/A/ALEALB01_Alex_Albon/alealb01.png"
      },
      %{
        id: 14,
        name: "Franco Colapinto",
        number: 43,
        team: "Williams",
        nationality: "Argentina",
        bio: "Estreante em 2024, representa a nova geração sul-americana.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/F/FRACOL01_Franco_Colapinto/fracol01.png"
      },
      %{
        id: 15,
        name: "Yuki Tsunoda",
        number: 22,
        team: "RB",
        nationality: "Japão",
        bio: "Piloto agressivo, destaque da academia Red Bull.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/Y/YUKTSU01_Yuki_Tsunoda/yuktsu01.png"
      },
      %{
        id: 16,
        name: "Liam Lawson",
        number: 30,
        team: "RB",
        nationality: "Nova Zelândia",
        bio: "Substituto promissor, impressionou em 2023.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png"
      },
      %{
        id: 17,
        name: "Valtteri Bottas",
        number: 77,
        team: "Sauber",
        nationality: "Finlândia",
        bio: "Ex-piloto da Mercedes, traz experiência à Sauber.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/V/VALBOT01_Valtteri_Bottas/valbot01.png"
      },
      %{
        id: 18,
        name: "Zhou Guanyu",
        number: 24,
        team: "Sauber",
        nationality: "China",
        bio: "Primeiro chinês na F1, busca seu primeiro pódio.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/Z/ZHOGU01_Zhou_Guanyu/zhogu01.png"
      },
      %{
        id: 19,
        name: "Kevin Magnussen",
        number: 20,
        team: "Haas",
        nationality: "Dinamarca",
        bio: "Veterano combativo, conhecido por defesas agressivas.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/K/KEVMAG01_Kevin_Magnussen/kevmag01.png"
      },
      %{
        id: 20,
        name: "Nico Hülkenberg",
        number: 27,
        team: "Haas",
        nationality: "Alemanha",
        bio: "Veterano sem pódio, mas respeitado por sua velocidade.",
        image: "https://www.formula1.com/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png"
      }
    ]

    render(conn, :index, teams: teams, drivers: drivers)
  end
end
